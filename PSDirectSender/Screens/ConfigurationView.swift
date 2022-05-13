//
//  ConfigurationView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import SwiftUI

fileprivate class HelpShow: ObservableObject {
    @Published var serverIP: Bool = false
    @Published var serverPort: Bool = false
    
    @Published var consoleIP: Bool = false
    @Published var consolePort: Bool = false
}

struct ConfigurationView: View {
    @EnvironmentObject var connection: ConnectionDetails
    @StateObject var inputConnectionData: ConnectionDetails = ConnectionDetails()
    
    @StateObject fileprivate var helpShow: HelpShow = HelpShow()
    @State var showingAlert: Bool = false
    @State var showingConnectionStatus: Bool = false
    
    @State var connectionStatusLoaded: Bool = false
    
    @State var nonLocalizedPopover: Bool = false
    @State var localizedPopover: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 25) {
                
                VStack {
                    Text("Server Configuration")
                        .font(.title3)
                        .opacity(0.6)
                    Group {
                        HStack {
                            Text("IP Address")
                            ZStack {
                                TextField("192.168.1.100", text: $inputConnectionData.serverIP)
                                HStack {
                                    Spacer()
                                    Menu("") {
                                        ForEach(inputConnectionData.networkingIPs, id: \.self) { networkingIP in
                                            Button("\(networkingIP)") {
                                                inputConnectionData.serverIP = networkingIP
                                            }
                                        }
                                    }
                                    .menuStyle(BorderlessButtonMenuStyle())
                                    .frame(width: 20)
                                }
                                .padding(.trailing, 10.0)
                                
                            }
                            Button {
                                helpShow.serverIP.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }.popover(isPresented: $helpShow.serverIP) {
                                Text(message.serverIPHelp)
                                    .padding()
                            }
                            
                        }
                        HStack {
                            Text("Port")
                            TextField("15460", text: $inputConnectionData.serverPort)
                            Button {
                                helpShow.serverPort.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }.popover(isPresented: $helpShow.serverPort) {
                                Text(message.serverPortHelp)
                                    .padding()
                            }
                        }
                    }
                }.onAppear(perform: {
                    if inputConnectionData.serverIP.isEmpty {
                        inputConnectionData.generateServerDetails()
                    }
                })
                
                VStack {
                    Text("Remote Package Installer Configuration")
                        .font(.title3)
                        .opacity(0.6)
                    Group {
                        HStack {
                            Text("IP Address")
                            TextField("192.168.1.100 (example)", text: $inputConnectionData.consoleIP)
                            Button {
                                helpShow.consoleIP.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }.popover(isPresented: $helpShow.consoleIP) {
                                Text(message.consoleIPHelp)
                                    .padding()
                            }
                        }
                        HStack {
                            Text("RPI Port")
                            TextField("12800 (default)", text: $inputConnectionData.consolePort)
                            Button {
                                helpShow.consolePort.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }.popover(isPresented: $helpShow.consolePort) {
                                Text(message.consolePortHelp)
                                    .padding()
                            }
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
            }
            .padding()
            .frame(maxWidth: 500)
            
            Button("Apply Settings and Restart Server") {
                let a1 = networking.checkIfIPIsCorrect(ip: inputConnectionData.serverIP)
                let a2 = networking.checkIfPortIsCorrect(port: inputConnectionData.serverPort)
                
                let b1 = networking.checkIfIPIsCorrect(ip: inputConnectionData.consoleIP)
                let b2 = networking.checkIfPortIsCorrect(port: inputConnectionData.consolePort)
                
                if !everythingIsTrue(a1, a2, b1, b2) {
                    showingAlert = true
                    return
                }
                
                connection.serverIP = inputConnectionData.serverIP
                connection.serverPort = inputConnectionData.serverPort
                
                connection.consoleIP = inputConnectionData.consoleIP
                connection.consolePort = inputConnectionData.consolePort
                
                connection.addLog("""
Staring web server:
[SERVER] IP: \(connection.serverIP) Port: \(connection.serverPort)
[CONSOLE] IP: \(connection.consoleIP) Port: \(connection.consolePort)
""")
                swiftStartServer(serverIP: connection.serverIP, serverPort: connection.serverPort)
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Important message"), message: Text("Invalid configuration data"), dismissButton: .default(Text("Got it!")))
            }
            
            Button("Check Server status") {
                showingConnectionStatus.toggle()
            }.popover(isPresented: $showingConnectionStatus, content: {
                
                VStack {
                    if !connectionStatusLoaded {
                        ProgressView()
                    } else {
                        ServerStatusView(serverStatus: $connection.connectionStatus)
                            .frame(height: 40)
                    }
                }
                .frame(minWidth: 200)
                .padding()
                .onAppear(perform: {
                    connectionStatusLoaded = false
                    DispatchQueue.global(qos: .background).async {
                        sleep(1)
                        
                        if !server.serverIsRunning() {
                            connectionStatusLoaded = true
                            return
                        }
                        
                        let status = checkIfServerIsWorking(serverIP: connection.serverIP, serverPort: connection.serverPort)
                        DispatchQueue.main.async {
                            connection.connectionStatus = status
                            connectionStatusLoaded = true
                        }
                    }
                })
            })
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        let view = ConfigurationView()
            .environmentObject(ConnectionDetails())
        view
        view
            .environment(\.locale, .init(identifier: "Russian"))
        
    }
}
