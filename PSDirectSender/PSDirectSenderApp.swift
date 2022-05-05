//
//  PSDirectSenderApp.swift
//  PSDirectSender
//
//  Created by Macintosh on 22.04.2022.
//

import SwiftUI

let networking = Networking()
let server = ServerBridge()
let fileMgr: FileManager = FileManager.default
let tempDirectory: URL = fileMgr.temporaryDirectory.appendingPathComponent("PSDirectSenderLinks")

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
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification), perform: { _ in
                    NSApp.mainWindow?.standardWindowButton(.zoomButton)?.isEnabled = false
                }
                )
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

extension URLSession {
    func synchronousDataTask(with url: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
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

extension NSTabView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        tabViewBorderType = .none
        tabPosition = .none
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

/*extension FileManager {
    func fileExists(_ atPath: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: atPath, isDirectory:&isDirectory)
        return exists && !isDirectory.boolValue
    }
}*/

func createTempDirPackageAlias(package: packageURL) -> String?{
    
    do {
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true, attributes: nil)
    } catch {
        print(error)
    }
    
    do {
        let symlinkPackageLocation = tempDirectory.appendingPathComponent(package.id.uuidString).appendingPathExtension("pkg")
        let packageURL = package.url
        
        if !(FileManager.default.fileExists(atPath: symlinkPackageLocation.path)) {
            try fileMgr.createSymbolicLink(atPath: symlinkPackageLocation.path,
                                           withDestinationPath: packageURL.path)
            print("Link successful: [\(symlinkPackageLocation.path)] <-> [\(packageURL.path)]")
        } else {
            print("Symlink already exists.")
        }
        
        return package.id.uuidString + ".pkg"
        
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
    
    return []
}

func swiftStartServer(serverIP: String, serverPort: String){
    do {
        server.setDirectoryPath(tempDirectory.path)
        server.setServerBaseURL(try networking.buildServerBaseURL(ip: serverIP, port: Int(serverPort) ?? -1))
        
        DispatchQueue.global(qos: .background).async {
            server.stopServer()
            sleep(1)
            server.startServer()
        }
        
    } catch {
        print("[ERROR:] Can't build correct url.")
    }
}

@discardableResult
func sendPackagesToConsole(packageFilename: String, consoleIP: String, consolePort: Int, serverIP: String, serverPort: Int) -> Any?{

    let dataStructure = structPackageSender(type: "direct", packages: ["http://\(serverIP):\(serverPort)/\(packageFilename)"])
    let jsonData = try? JSONEncoder().encode(dataStructure)
    
    let builtURL = URL(string: "http://\(consoleIP):\(consolePort)/api/install")
    
    var request = URLRequest(
        url: (builtURL)!,
        cachePolicy: .reloadIgnoringLocalCacheData
    )
    
    request.httpBody = jsonData
    request.httpMethod = "POST"
    request.addValue("PSDirectSender/\(Bundle.main.appVersionLong)", forHTTPHeaderField: "User-Agent")
    request.addValue("PSDirectSender/Mongoose", forHTTPHeaderField: "Server")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _/*response*/, _/*error*/) = URLSession.shared.synchronousDataTask(with: request)

    if let data = data {
        if let json = try? JSONDecoder().decode(structSendSuccess.self, from: data){
            return json
        } else if let json = try? JSONDecoder().decode(structSendFailure.self, from: data){
            return json
        } else {
            return String(decoding: data, as: UTF8.self)
        }
    }
    
    return nil
}

func checkIfServerIsWorking(serverIP: String, serverPort: String) -> ServerStatus {
    guard let url = URL(string: "http://\(serverIP):\(serverPort)") else {
        return .fail
    }
    var status: ServerStatus = .stopped

    var request = URLRequest(
        url: url,
        cachePolicy: .reloadIgnoringLocalCacheData
    )
    request.httpMethod = "HEAD"
    request.timeoutInterval = 3
    
    let (_/*data*/, response, _/*error*/) = URLSession.shared.synchronousDataTask(with: request)
    
    if let httpResponse = response as? HTTPURLResponse,  let serverHeader = httpResponse.allHeaderFields["Server"] as? String {
        if serverHeader == "PSDirectSender/Mongoose"{
            status = .success
            print("[DEBUG:] \(serverHeader)")
        } else {
            status = .fail
        }
    } else {
        status = .fail
    }

    return status
}

func everythingIsTrue(_ bools: Bool...) -> Bool {
    for bool in bools where bool == false{
        return false
    }
    return true;
}

func getStringDate() -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return df.string(from: Date())
}
