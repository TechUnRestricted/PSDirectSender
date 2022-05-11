//
//  QueueView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

enum packageState {
    case sendNotInitiated
    case sendSuccess
    case sendFailure
}

extension packageState {
    var color: Color {
        get {
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
}

struct packageURL{
    let id = UUID()
    let url: URL
    var state: packageState = .sendNotInitiated
}

fileprivate struct AlertIdentifier: Identifiable {
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
    @EnvironmentObject var vm: ConnectionDetails
    @State fileprivate var alert: AlertIdentifier?
    @State var packageURLs: [packageURL] = []
    @State private var selection: Set<UUID> = []
    
    @State var isInDropArea: Bool = false
    @State var loadingScreenIsShown: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack{
                HStack(spacing: 15){
                    ColorButton(text: "Add", color: .orange, image: Image(systemName: "plus.rectangle.on.rectangle"), action: {
                        let packages = selectPackages()
                        for package in packages{
                            if let package = package {
                                packageURLs.append(packageURL(url: package))
                            }
                        }
                    })
                    
                    ColorButton(text: "Send", color: .green, image: Image(systemName: "arrow.up.forward.app"), action: {
                        if packageURLs.isEmpty { return }
                        
                        
                        if (vm.serverIP.isEmpty || vm.serverPort.isEmpty){
                            vm.generateServerDetails()
                        }
                        
                        if (vm.serverIP.isEmpty || vm.serverPort.isEmpty){
                            vm.addLog("Can't get server configuration.")
                            alert = AlertIdentifier(id: .cantGetServerConfiguration)
                            return
                        }
                        
                        if (vm.consoleIP.isEmpty || vm.consolePort.isEmpty){
                            vm.addLog("Can't get console configuration.")
                            alert = AlertIdentifier(id: .cantGetConsoleConfiguration)
                            return
                        }
                        
                        loadingScreenIsShown = true
                        DispatchQueue.global(qos: .background).async {
                        loop: for index in packageURLs.indices {
                            if (packageURLs[index].state == .sendSuccess) {
                                continue
                            }
                            let alias = createTempDirPackageAlias(package: packageURLs[index])!
                            
                            vm.addLog("Creating package alias (\"\(packageURLs[index].url.path)\" -> \"\(tempDirectory.path)/\(alias)\").")
                            vm.addLog("Sending package \"\(alias)\" to the console (IP: \(vm.consoleIP), Port: \(vm.consolePort))")
                            
                            let response = sendPackagesToConsole(packageFilename: alias, consoleIP: vm.consoleIP, consolePort: Int(vm.consolePort)!, serverIP: vm.serverIP, serverPort: Int(vm.serverPort)!)
                            
                            if (response == nil || response as? String == ""){
                                vm.addLog("Can't get response from console ([Console] IP: \(vm.consoleIP), Port: \(vm.consolePort))")
                                DispatchQueue.main.async {
                                    if loadingScreenIsShown {
                                        alert = AlertIdentifier(id: .cantGetResponseFromConsole)
                                    }
                                }
                                break
                            } else if let x = response as? structSendSuccess {
                                vm.addLog("Successfully sent \(packageURLs[index].url) [Package Link: \"\(packageURLs[index].id).pkg\", id: \(x.taskID), title: \"\(x.title)\"]")
                                DispatchQueue.main.async {
                                    packageURLs[index].state = .sendSuccess
                                }
                            } else if let x = response as? structSendFailure {
                                vm.addLog("An error occurred while sending \(packageURLs[index].url) [\(packageURLs[index].id).pkg] {ERROR: \(x.error)}")
                                DispatchQueue.main.async {
                                    packageURLs[index].state = .sendFailure
                                }
                                break
                            }
                        }
                            DispatchQueue.main.async {
                                loadingScreenIsShown = false
                            }
                            
                        }
                        
                    })
                    
                    
                    ColorButton(text: "Delete", color: .red, image: Image(systemName: "trash"), action: {
                        deleteSelection()
                    }).onDeleteCommand(perform: selection.isEmpty ? nil: deleteSelection)
                    
                }.padding()
                
                List(selection: $selection){
                    ForEach(packageURLs, id: \.id){ package in
                        HStack{
                            Image(systemName: "shippingbox")
                            Text("\(package.url.lastPathComponent)")
                        }
                        .font(.title3)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(package.state.color.opacity(0.5).cornerRadius(5))
                        
                        .swiftyListDivider()
                    }
                }
                .onDrop(of: [.fileURL], isTargeted: $isInDropArea, perform: { providers in
                    for provider in providers {
                        let _ = provider.loadObject(ofClass: URL.self) { object, error in
                            if let url = object, url.pathExtension == "pkg"{
                                packageURLs.append(packageURL(url: url))
                            }
                        }
                    }
                    return true
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1.5)
                )
                
            }
            .padding()
            .alert(item: $alert) {
                  $0.id.alertView
            }
            
            ZStack{
                VisualEffectView(material: .fullScreenUI, blendingMode: .withinWindow)
                VStack(spacing: 0){
                    VStack(spacing: 15){
                        ProgressView()
                        Text("Sending packages...").opacity(0.8)
                    }
                    .frame(minWidth: 200)
                    .padding()
                    .background((colorScheme == .light ? Color.white : Color.black).opacity(0.5))
                    .cornerRadius(20)
                    .padding()
                    Button("Cancel"){
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
        packageURLs.removeAll { selection.contains($0.id) }
        selection.removeAll()
    }
}

struct QueueView_Previews: PreviewProvider {
    @EnvironmentObject var vm: ConnectionDetails
    
    static var previews: some View {
        let view = QueueView(packageURLs: [
            packageURL(url: URL(string: "https://example.com/game.pkg")!),
            packageURL(url: URL(string: "https://example.com/dlc.pkg")!, state: .sendSuccess),
            packageURL(url: URL(string: "https://example.com/dlc.pkg")!, state: .sendFailure)
        ]).environmentObject(ConnectionDetails())
        
        view
        view
            .environment(\.locale, .init(identifier: "Russian"))

    }
}
