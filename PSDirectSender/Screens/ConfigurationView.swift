//
//  ConfigurationView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var connection: ConnectionDetails
    
    @State var networkingIPs : [String] = []
    
    @State var showingAlert : Bool = false;
    @State var alertText : String = ""
    
    @State private var checked = true
    
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
                            VDKComboBox(items: $networkingIPs, text: $connection.serverIP)
                        }.onAppear(perform: {
                            if connection.serverIP.isEmpty {
                                networkingIPs = networking.getIPNetworkAddresses()
                                if let ip = networkingIPs.first{
                                    connection.serverIP = ip;
                                }
                            }
                        })
                        HStack{
                            Text("Port")
                            TextField("15460", text: $connection.serverPort).onAppear(perform: {
                                if connection.serverPort.isEmpty{
                                    connection.serverPort = String(networking.findFreePort())
                                }
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
                            TextField("192.168.1.100 (example)", text: $connection.consoleIP)
                        }
                        HStack{
                            Text("RPI Port")
                            TextField("12800 (default)", text: $connection.consolePort)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
            }
            .padding()
            .frame(maxWidth: 500)
            
            Button("Apply Settings and Restart Server"){
                swiftStartServer(serverIP: connection.serverIP, serverPort: connection.serverPort)
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Important message"), message: Text(alertText), dismissButton: .default(Text("Got it!")))
            }
            ServerStatusView(serverStatus: $connection.connectionStatus)
                .frame(height: 40)
                .onAppear(perform: {
                    DispatchQueue.global(qos: .background).async {
                        while(true){
                            let x = checkIfServerIsWorking(serverIP: connection.serverIP, serverPort: connection.serverPort)
                            DispatchQueue.main.async {
                                connection.connectionStatus = x
                            }
                            sleep(1)
                        }
                    }
                })
        }
    }
}



struct ConfigurationView_Previews: PreviewProvider {
    @StateObject var currentTheme = ConnectionDetails()
    
    static var previews: some View {
        ConfigurationView()
            .environmentObject(ConnectionDetails())
    }
}

