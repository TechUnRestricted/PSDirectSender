//
//  QueueView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct QueueView: View {
    @EnvironmentObject var vm: ConnectionDetails
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

                }
                
            }
            
            .padding()
        
    }
}

struct QueueView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
