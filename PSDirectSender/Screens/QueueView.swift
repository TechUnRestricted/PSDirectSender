//
//  QueueView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct QueueView: View {
    @Binding var serverIP : String
    @Binding var serverPort : String
    @Binding var consoleIP : String
    @Binding var consolePort : String
    
    @State var packageURLs: [URL] = []

    var body: some View {
            VStack{
                HStack{
                    Button("Add"){
                        let packages = selectPackages()
                        for package in packages{
                            if let package = package {
                                packageURLs.append(package)
                            }
                        }
                    }
                    Button("Send"){
                        
                    }
                    
                }
                List(packageURLs, id: \.self){ package in
                        Text("\(package.lastPathComponent)")
                    Divider()

                }//.listStyle(InsetListStyle())
                
            }
            
            .padding()
        
    }
}

struct QueueView_Previews: PreviewProvider {
    static var previews: some View {
        QueueView(serverIP: .constant("192.168.100.9"), serverPort: .constant("19132"), consoleIP: .constant("192.168.100.128"), consolePort: .constant("12200"))
    }
}
