//
//  QueueView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct packageURL{
    var id = UUID()
    var url : URL
}

fileprivate class AlertState: ObservableObject {
    @Published var showCantGetServerConfiguration : Bool = false
    @Published var showCantGetConsoleConfiguration : Bool = false
    
    let messageCantGetServerConfiguration = """
Network connection was not detected.

If there is a connection, then specify the IP address of your network card and any port in the Configuration section.
"""
    
    let messageCantGetConsoleConfiguration = """
Console connection configuration data is missing.

Go to the Configuration section and correctly fill in the text fields.
"""
}

struct QueueView: View {
    @EnvironmentObject var vm: ConnectionDetails
    @StateObject fileprivate var alertState : AlertState = AlertState()
    @State var packageURLs: [packageURL] = []
    @State private var selection: Set<UUID> = []
    
    @State var isInDropArea : Bool = false
    
    var body: some View {
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
                    if (vm.serverIP.isEmpty || vm.serverPort.isEmpty){
                        vm.generateServerDetails()
                    }
                    
                    if (vm.serverIP.isEmpty || vm.serverPort.isEmpty){
                        vm.addLog("Can't get server configuration.")
                        alertState.showCantGetServerConfiguration = true
                        return
                    }
                    
                    if (vm.consoleIP.isEmpty || vm.consolePort.isEmpty){
                        vm.addLog("Can't get console configuration.")
                        alertState.showCantGetConsoleConfiguration = true
                        return
                    }
                    
                    var linkAliases: [String] = []
                    for packageURL in packageURLs{
                        let alias = createTempDirPackageAlias(packageURL: packageURL.url)!
                        linkAliases.append(alias)
                        vm.addLog("Creating package alias (\"\(packageURL.url.path)\" -> \"\(tempDirectory.path)\(alias)\").")
                    }
                    vm.addLog("Sending packages \(linkAliases) to the console (IP: \(vm.consoleIP), Port: \(vm.consolePort)")
                    sendPackagesToConsole(urlsPKG: linkAliases, consoleIP: vm.consoleIP, consolePort: Int(vm.consolePort)!)
                })
                    .alert(isPresented: $alertState.showCantGetConsoleConfiguration) {
                        Alert(title: Text("Important message"), message: Text(alertState.messageCantGetConsoleConfiguration), dismissButton: .default(Text("Got it!")))
                    }
                
                ColorButton(text: "Delete", color: .red, image: Image(systemName: "trash"), action: {
                    deleteSelection()
                }).onDeleteCommand(perform: selection.isEmpty ? nil : deleteSelection)
                
            }.padding()
                .alert(isPresented: $alertState.showCantGetServerConfiguration) {
                    Alert(title: Text("Important message"), message: Text(alertState.messageCantGetServerConfiguration), dismissButton: .default(Text("Got it!")))
                }
            
            
            List(selection: $selection){
                ForEach(packageURLs, id: \.id){ package in
                    HStack{
                        Image(systemName: "shippingbox")
                        Text("\(package.url.lastPathComponent)")
                    }
                    .font(.title3)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
        //.frame(maxWidth: 920, maxHeight: 650)
        
    }
    private func deleteSelection() {
        packageURLs.removeAll { selection.contains($0.id) }
        selection.removeAll()
    }
}

struct QueueView_Previews: PreviewProvider {
    @EnvironmentObject var vm: ConnectionDetails
    
    static var previews: some View {
        QueueView(packageURLs: [
            packageURL(url: URL(string: "https://example.com/game.pkg")!),
            packageURL(url: URL(string: "https://example.com/dlc.pkg")!)
            
        ]).environmentObject(ConnectionDetails())
    }
}
