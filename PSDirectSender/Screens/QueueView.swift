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

struct QueueView: View {
    @EnvironmentObject var vm: ConnectionDetails
    @State var packageURLs: [packageURL] = []
    @State private var selection: Set<UUID> = []
    
    var body: some View {
        VStack{
            HStack(spacing: 15){
                ColorButton(text: "Add", color: .orange, image: Image(systemName: "plus.rectangle.on.rectangle"), handler: {
                    let packages = selectPackages()
                    for package in packages{
                        if let package = package {
                            packageURLs.append(packageURL(url: package))
                        }
                    }
                })
           
                ColorButton(text: "Send", color: .green, image: Image(systemName: "arrow.up.forward.app"), handler: {
                    var linkAliases: [String] = []
                    for packageURL in packageURLs{
                        let alias = createTempDirPackageAlias(packageURL: packageURL.url)!
                        linkAliases.append(alias)
                        vm.addLog("Creating package alias (\"\(packageURL.url.path)\" -> \"\(tempDirectory.path)\(alias)\").")
                    }
                    vm.addLog("Sending packages \(linkAliases) to the console (IP: \(vm.consoleIP), Port: \(vm.consolePort)")
                    sendPackagesToConsole(urlsPKG: linkAliases, consoleIP: vm.consoleIP, consolePort: Int(vm.consolePort)!)
                })
            
                ColorButton(text: "Delete", color: .red, image: Image(systemName: "trash"), handler: {
                    deleteSelection()
                }).onDeleteCommand(perform: selection.isEmpty ? nil : deleteSelection)
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
                    .swiftyListDivider()
                }
            }
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                )
            
        }
        .padding()
        
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
