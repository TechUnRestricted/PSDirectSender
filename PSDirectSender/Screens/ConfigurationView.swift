//
//  ConfigurationView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct ConfigurationView: View {
    @State var serverIP : String = ""
    @State var serverPort : String = "15460"
    @State var consoleIP : String = ""
    @State var consolePort : String = "12800"
    
    @State var networkingPorts : [String] = []
    @State var test = 1
    
    @State var showingAlert : Bool = false;
    @State var alertText : String = ""
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 25){
                
                VStack(){
                    Text("Server Configuration")
                        .font(.title3)
                        .opacity(0.6)
                    Group{
                        HStack{
                            Text("IP Address")
                            VDKComboBox(items: $networkingPorts, text: $serverIP)
                        }.onAppear(perform: {
                            networkingPorts = networking.getIPNetworkAddresses()
                            if let ip = networkingPorts.first, serverIP.isEmpty{
                                serverIP = ip;
                            }
                        })
                        HStack{
                            Text("Port")
                            TextField("15460", text: $serverPort).onAppear(perform: {
                                serverPort = String(networking.findFreePort())
                            })
                        }
                    }
                }
                
                VStack{
                    Text("Remote Package Installer Configuration")
                        .font(.title3)
                        .opacity(0.6)
                    Group{
                        HStack{
                            Text("Console IP Address")
                            TextField("192.168.1.100 (example)", text: $consoleIP)
                        }
                        HStack{
                            Text("RPI Port")
                            TextField("12800 (default)", text: $consolePort)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
            }
            .padding()
            .frame(maxWidth: 500)
            
            Button("Apply Settings and Restart Server"){
                    swiftStartServer(serverIP: serverIP, serverPort: serverPort)
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Important message"), message: Text(alertText), dismissButton: .default(Text("Got it!")))
            }
        }
    }
}



struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
            .frame(width: 300, height: 250)
    }
}

