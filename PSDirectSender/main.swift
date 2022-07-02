//
//  main.swift
//  PSDirectSender
//
//  Created by Macintosh on 25.06.2022.
//

import Foundation
import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}

extension NSImage.Name {
    static let appIcon = NSImage.Name("AppIcon")

    static let queue = NSImage.Name("Queue")
    static let configuration = NSImage.Name("Configuration")
    static let logs = NSImage.Name("Logs")
    static let info = NSImage.Name("Info")
    
    static let add = NSImage.Name("Add")
    static let send = NSImage.Name("Send")
    static let delete = NSImage.Name("Delete")

}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension Int {
    func isInRange(_ start: Int, _ end: Int) -> Bool {
        return self >= start && self <= end
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
    // public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
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
