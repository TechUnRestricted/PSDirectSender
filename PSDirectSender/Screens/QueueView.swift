//
//  QueueView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

enum PackageState {
    case sendNotInitiated
    case sendSuccess
    case sendFailure
}

extension PackageState {
    var color: Color {
        switch self {
        case .sendNotInitiated:
            return Color.clear
        case .sendSuccess:
            return Color.green
        case .sendFailure:
            return Color.red
        }
    }
}

struct Package {
    let id = UUID()
    let url: URL
    var task_id: Int?
    var title_id: String?
    var state: PackageState = .sendNotInitiated
}

private struct AlertIdentifier: Identifiable {
    enum ActiveAlert {
        case cantGetServerConfiguration
        case cantGetConsoleConfiguration
        case cantGetResponseFromConsole
        
        var alertView: Alert {
            switch self {
            case .cantGetServerConfiguration:
                return Alert(title: Text("Important message"), message: Text(message.cantGetServerConfiguration))
                
            case .cantGetConsoleConfiguration:
                return Alert(title: Text("Important message"), message: Text(message.cantGetConsoleConfiguration))
                
            case .cantGetResponseFromConsole:
                return Alert(title: Text("Important message"), message: Text(message.cantGetResponseFromConsole))
                
            }
        }
    }
    
    var id: ActiveAlert
}

struct QueueView: View {
    @EnvironmentObject var connection: ConnectionDetails
    @EnvironmentObject var logsCollector: LogsCollector
    
    @State fileprivate var alert: AlertIdentifier?
    @State var packages: [Package] = []
    @State private var selection: Set<UUID> = []
    
    @State var isInDropArea: Bool = false
    @State var loadingScreenIsShown: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    AddButton()
                    SendButton()
                    DeleteButton()
                        .onDeleteCommand(perform: selection.isEmpty ? nil: deleteSelection)
                    
                }.padding()
                
                List(selection: $selection) {
                    ForEach(packages, id: \.id) { package in
                        HStack {
                            Image(systemName: "shippingbox")
                            Text("\(package.title_id ?? package.url.lastPathComponent)")
                        }
                        .font(.title3)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(package.state.color.opacity(0.5).cornerRadius(5))
                        .swiftyListDivider()
                        .contextMenu(menuItems: {
                            Button("Remove item from queue") {
                                deleteSelection()
                            }
                        })
                    }
                }
                .onDrop(of: [.fileURL], isTargeted: $isInDropArea) { providers in
                    for provider in providers {
                        _ = provider.loadObject(ofClass: URL.self) { object, _ in
                            if let url = object, url.pathExtension == "pkg"{
                                let packageDetails = PackageExplorer(fileURL: url)
                                var title: String?
                                
                                if let packageDetails = packageDetails.packageContents?.paramSFOData {
                                    title = packageDetails["TITLE"]
                                    if let title = title {
                                        logsCollector.addLog("Package name defined: \"\(title)\" (\"\(url)\")")
                                    } else {
                                        logsCollector.addLog("Package name for (\"\(url)\") is undefined. Maybe the package is damaged or not compatible with the PS4 system.")
                                    }
                                }
                                /*if let packageDetails = packageDetails {
                                    title = packageDetails["TITLE"]
                                    if let title = title {
                                        logsCollector.addLog("Package name defined: \"\(title)\" (\"\(url)\")")
                                    } else {
                                        logsCollector.addLog("Package name for (\"\(url)\") is undefined. Maybe the package is damaged or not compatible with the PS4 system.")
                                    }
                                }*/
                                
                                packages.append(Package(url: url, title_id: title))
                            }
                        }
                    }
                    return true
                }
                .overlay(
                    ZStack {
                    ZStack {
                        VisualEffectView(material: .fullScreenUI, blendingMode: .withinWindow)
                        VStack {
                            Image(systemName: "shippingbox")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Drop .pkg files")
                                .font(.title)
                        }
                        .opacity(0.5)
                    }
                    .cornerRadius(16)
                    .hidden(!isInDropArea)
                        
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            Color.gray.opacity(0.4),
                            lineWidth: 1.5
                        )
                    }
                )
                
            }
            .padding()
            .alert(item: $alert) {
                $0.id.alertView
            }
            
            ZStack {
                VisualEffectView(material: .fullScreenUI, blendingMode: .withinWindow)
                VStack(spacing: 0) {
                    VStack(spacing: 15) {
                        ProgressView()
                        Text("Sending packages...").opacity(0.8)
                    }
                    .frame(minWidth: 200)
                    .padding()
                    .background((colorScheme == .light ? Color.white : Color.black).opacity(0.5))
                    .cornerRadius(20)
                    .padding()
                    Button("Cancel") {
                        loadingScreenIsShown = false
                    }.buttonStyle(LinkButtonStyle())
                        .frame(minWidth: 80)
                        .padding(8)
                        .background((colorScheme == .light ? Color.white : Color.black).opacity(0.5))
                        .cornerRadius(8)
                }
            }.hidden(!loadingScreenIsShown)
            
        }
        
    }
    
    private func deleteSelection() {
        packages.removeAll { selection.contains($0.id) }
        selection.removeAll()
    }
    
    fileprivate func AddButton() -> ColorButton {
        return ColorButton(text: "Add", color: .orange, image: Image(systemName: "plus.rectangle.on.rectangle"), action: {
            let selectedPackages = selectPackages()
            for package in selectedPackages {
                if let package = package {
                    let packageDetails = PackageExplorer(fileURL: package)
                    var title: String?
                    if let packageDetails = packageDetails.packageContents?.paramSFOData {
                        title = packageDetails["TITLE"]
                    }
                    packages.append(Package(url: package, title_id: title))
                }
            }
        })
    }
    
    fileprivate func SendButton() -> ColorButton {
        return ColorButton(text: "Send", color: .green, image: Image(systemName: "arrow.up.forward.app"), action: {
            if packages.isEmpty { return }
            
            if connection.serverIP.isEmpty || connection.serverPort.isEmpty {
                connection.generateServerDetails()
            }
            
            if connection.serverIP.isEmpty || connection.serverPort.isEmpty {
                logsCollector.addLog("Can't get server configuration.")
                alert = AlertIdentifier(id: .cantGetServerConfiguration)
                return
            }
            
            if connection.consoleIP.isEmpty || connection.consolePort.isEmpty {
                logsCollector.addLog("Can't get console configuration.")
                alert = AlertIdentifier(id: .cantGetConsoleConfiguration)
                return
            }
            
            loadingScreenIsShown = true
            DispatchQueue.global(qos: .background).async {
                for index in packages.indices {
                    if packages[index].state == .sendSuccess {
                        continue
                    }
                    let alias = createTempDirPackageAlias(package: packages[index])!
                    
                    logsCollector.addLog("Creating package alias (\"\(packages[index].url.path)\" -> \"\(tempDirectory.path)/\(alias)\").")
                    logsCollector.addLog("Sending package \"\(alias)\" to the console (IP: \(connection.consoleIP), Port: \(connection.consolePort))")
                    
                    let response = sendPackagesToConsole(packageFilename: alias, connection: connection)
                    
                    if response == nil || response as? String == "" {
                        logsCollector.addLog("Can't get response from console ([Console] IP: \(connection.consoleIP), Port: \(connection.consolePort))")
                        DispatchQueue.main.async {
                            if loadingScreenIsShown {
                                alert = AlertIdentifier(id: .cantGetResponseFromConsole)
                            }
                        }
                        break
                    } else if let response = response as? SendSuccess {
                        logsCollector.addLog("Successfully sent \(packages[index].url) [Package Link: \"\(packages[index].id).pkg\", id: \(response.taskID), title: \"\(response.title)\"]")
                        DispatchQueue.main.async {
                            packages[index].state = .sendSuccess
                            packages[index].task_id = response.taskID
                        }
                    } else if let response = response as? SendFailure {
                        logsCollector.addLog("An error occurred while sending \(packages[index].url) [\(packages[index].id).pkg] {ERROR: \(response.error)}")
                        DispatchQueue.main.async {
                            packages[index].state = .sendFailure
                        }
                        break
                    }
                }
                DispatchQueue.main.async {
                    loadingScreenIsShown = false
                }
                
            }
            
        })
    }
    
    fileprivate func DeleteButton() -> ColorButton {
        return ColorButton(text: "Delete", color: .red, image: Image(systemName: "trash"), action: {
            deleteSelection()
        })
    }
}

struct QueueView_Previews: PreviewProvider {
    @EnvironmentObject var connection: ConnectionDetails
    
    static var previews: some View {
        let view = QueueView(packages: [
            Package(url: URL(string: "https://example.com/game.pkg")!),
            Package(url: URL(string: "https://example.com/dlc.pkg")!, state: .sendSuccess),
            Package(url: URL(string: "https://example.com/dlc.pkg")!, state: .sendFailure)
        ]).environmentObject(ConnectionDetails())
        
        view
        view
            .environment(\.locale, .init(identifier: "Russian"))
        
    }
}
