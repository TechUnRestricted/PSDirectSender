//
//  PSDirectSenderApp.swift
//  PSDirectSender
//
//  Created by Macintosh on 22.04.2022.
//

import SwiftUI

let networking = Networking()
let server = MongooseBridge()
let fileMgr = FileManager.default
let tempDirectory = fileMgr.temporaryDirectory

@main
struct PSDirectSenderApp: App {
    @StateObject var currentTheme = ConnectionDetails()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(currentTheme)
                .frame(minWidth: 650,
                       idealWidth: 750,
                       maxWidth: .infinity,
                       minHeight: 340,
                       idealHeight: 440,
                       maxHeight: .infinity
                )
                .navigationSubtitle("for Remote Package Installer")
        }
    }
}

func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension Int {
    func isInRange(_ start: Int, _ end: Int) -> Bool{
        return self >= start && self <= end
    }
}

extension View {
    func swiftyListDivider() -> some View {
        background(Divider().offset(y: 4.0), alignment: .bottom)
    }
}

extension Bundle {
    public var appName: String { getInfo("CFBundleName") }
    public var displayName: String { getInfo("CFBundleDisplayName") }
    public var language: String { getInfo("CFBundleDevelopmentRegion") }
    public var identifier: String { getInfo("CFBundleIdentifier") }
    public var copyright: String { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        backgroundColor = NSColor.clear
        
        if let esv = enclosingScrollView {
            esv.drawsBackground = false
        }
    }
}

extension NSTabView{
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        tabViewBorderType = .none
        tabPosition = .none
    }
}

func createTempDirPackageAlias(packageURL: URL) -> String?{
    let tempURL = tempDirectory
    let uuid = UUID().uuidString
    do {
        let atPath = tempURL.appendingPathComponent(uuid).appendingPathExtension("pkg").path
        let withDestinationPath = packageURL.path
        print(atPath, withDestinationPath)
        try fileMgr.createSymbolicLink(atPath: atPath,
                                       withDestinationPath: withDestinationPath)
        print("Link successful: [\(atPath)] <-> [\(withDestinationPath)]")
        return atPath
    } catch let error {
        print("Error: \(error.localizedDescription)")
    }
    return nil
}

func selectPackages() -> [URL?]{
     let dialog = NSOpenPanel()

     dialog.title                   = "Choose PKGs"
     dialog.showsResizeIndicator    = true
     dialog.showsHiddenFiles        = false
     dialog.allowsMultipleSelection = true
     dialog.canCreateDirectories    = true
     dialog.allowedFileTypes = ["pkg"]
     dialog.canChooseDirectories = false;

     if (dialog.runModal() == NSApplication.ModalResponse.OK) {
         return dialog.urls
     }

     return [nil]
 }

func swiftStartServer(serverIP : String, serverPort : String){
    do {
        server.setDirectoryPath(tempDirectory.path)
        server.setServerBaseURL(try networking.buildServerBaseURL(ip: serverIP, port: Int(serverPort) ?? -1))
        
        DispatchQueue.global(qos: .background).async {
            server.stopServer()
            sleep(1)
            server.startServer()
        }
        
    } catch {
        print("[ERROR:] Can't start server.")
    }
}

func sendPackagesToConsole(urlsPKG : [String], consoleIP : String, consolePort : Int) -> String{
    let urlSession = URLSession.shared

    let dataStructure = structPackageSender(type: "direct", packages: urlsPKG)
    let jsonData = try? JSONEncoder().encode(dataStructure)
    
    var request = URLRequest(
        url: (URL(string: "http://\(consoleIP):\(consolePort)")?.appendingPathComponent("api").appendingPathComponent("install"))!,
                cachePolicy: .reloadIgnoringLocalCacheData
    )
    print("[DEBUG:] \(request.url)")
    
    request.httpBody = jsonData
    request.httpMethod = "POST"
    request.addValue("PSDirectSender/\(Bundle.main.appVersionLong)", forHTTPHeaderField: "User-Agent")
    //request.addValue("PSDirectSender/Mongoose", forHTTPHeaderField: "Server")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let data = try! JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String:AnyObject]
    print(data)
    let task = urlSession.dataTask(
                with: request,
                completionHandler: { data, response, error in
                    print(response ?? "Can't get response")
                }
            )

    task.resume()
    
    return ""
}

func checkIfServerIsWorking(serverIP : String, serverPort : String) -> ServerStatus {
    guard let url = URL(string: "http://\(serverIP):\(serverPort)") else {
        return .fail
    }
    
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    
    var status : ServerStatus = .stopped
    
    let semaphore = DispatchSemaphore(value: 0)
    let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let httpResponse = response as? HTTPURLResponse,  let serverHeader = httpResponse.allHeaderFields["Server"] as? String {
            if serverHeader == "PSDirectSender/Mongoose"{
                status = .success
                print("[DEBUG:] \(serverHeader)")
            } else {
                status = .fail
            }
        }
        semaphore.signal()
    }.resume()

    semaphore.wait()
    
    return status
}

func everythingIsTrue(_ bools: Bool...) -> Bool {
    for bool in bools where bool == false{
        return false
    }
    return true;
}
