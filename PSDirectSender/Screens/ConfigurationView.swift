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
    
    let messageServerIP: LocalizedStringKey = """
This field is usually filled in automatically by the program.
It specifies the IP address of one of your network cards (Wi-Fi, Ethernet) on your Mac.

If this field was not filled in automatically, make sure that your computer is connected to the local network.
You can select the IP address of one of your network cards by clicking on the down arrow in the text field.
The IP address can also be found by going to [System Preferences -> Network -> (Device) -> IP Address]
"""
    
    let messageServerPort: LocalizedStringKey = """
This field is usually filled in automatically by the program.
If this field was not filled in automatically, make sure that your computer is connected to the local network.

You can specify any value between 0 and 65536, however, some ports may be busy/reserved for other applications.
"""
    
    let messageConsoleIP: LocalizedStringKey = """
This field must be filled in manually.

On your console go to the [Settings -> Network -> View Connection Status].
Find the IP Address entry and enter it into this field.
"""
    
    let messageConsolePort: LocalizedStringKey = """
This value set by default and should not be changed without special reason.
    
Points to the port used by the Remote Package Installer application on your console.
"""
    
}



struct ConfigurationView: View {
    @EnvironmentObject var connection: ConnectionDetails
    @StateObject var inputConnectionData: ConnectionDetails = ConnectionDetails()
    
    @StateObject fileprivate var helpShow: HelpShow = HelpShow()
    @State var showingAlert: Bool = false
    @State var showingConnectionStatus: Bool = false

    @State var alertText: String = ""
    @State var connectionStatusLoaded: Bool = false
    
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
                            ZStack{
                                TextField("192.168.1.100", text: $inputConnectionData.serverIP)
                                HStack(){
                                    Spacer()
                                    Menu("") {
                                        ForEach(inputConnectionData.networkingIPs, id: \.self) {
                                            networkingIP in
                                            Button("\(networkingIP)"){
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
                                Text(helpShow.messageServerIP)
                                    .padding()
                            }
                            
                        }
                        HStack{
                            Text("Port")
                            TextField("15460", text: $inputConnectionData.serverPort)
                            Button {
                                helpShow.serverPort.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }.popover(isPresented: $helpShow.serverPort) {
                                Text(helpShow.messageServerPort)
                                    .padding()
                            }
                        }
                    }
                }.onAppear(perform: {
                    if (inputConnectionData.serverIP.isEmpty){
                        inputConnectionData.generateServerDetails()
                    }
                })
                
                VStack{
                    Text("Remote Package Installer Configuration")
                        .font(.title3)
                        .opacity(0.6)
                    Group{
                        HStack{
                            Text("IP Address")
                            TextField("192.168.1.100 (example)", text: $inputConnectionData.consoleIP)
                            Button {
                                helpShow.consoleIP.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }.popover(isPresented: $helpShow.consoleIP) {
                                Text(helpShow.messageConsoleIP)
                                    .padding()
                            }
                        }
                        HStack{
                            Text("RPI Port")
                            TextField("12800 (default)", text: $inputConnectionData.consolePort)
                            Button {
                                helpShow.consolePort.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }.popover(isPresented: $helpShow.consolePort) {
                                Text(helpShow.messageConsolePort)
                                    .padding()
                            }
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
            }
            .padding()
            .frame(maxWidth: 500)
            
            Button("Apply Settings and Restart Server"){
                let a1 = networking.checkIfIPIsCorrect(ip: inputConnectionData.serverIP)
                let a2 = networking.checkIfPortIsCorrect(port: inputConnectionData.serverPort)
                
                let b1 = networking.checkIfIPIsCorrect(ip: inputConnectionData.consoleIP)
                let b2 = networking.checkIfPortIsCorrect(port: inputConnectionData.consolePort)
                
                if !everythingIsTrue(a1, a2, b1, b2){
                    alertText = "Invalid configuration data"
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
                Alert(title: Text("Important message"), message: Text(alertText), dismissButton: .default(Text("Got it!")))
            }
            Button("Check Server status"){
                showingConnectionStatus.toggle()
            }.popover(isPresented: $showingConnectionStatus, content: {
                VStack{
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

