//
//  ConfigurationView.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//
func placeOrder() { }
  func adjustOrder() { }
  func cancelOrder() { }
import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var connection: ConnectionDetails
    @StateObject var inputConnectionData: ConnectionDetails = ConnectionDetails()
    
    //@State var networkingIPs : [String] = []
    
    @State var showingAlert : Bool = false;
    @State var alertText : String = ""
    
    @State private var checked = true
    @State var sort = 1
  
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
                                print("Button was tapped")
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }
                            
                        }
                        HStack{
                            Text("Port")
                            TextField("15460", text: $inputConnectionData.serverPort)
                            Button {
                                print("Button was tapped")
                            } label: {
                                Image(systemName: "questionmark.circle")
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
                            Text("Console IP Address")
                            TextField("192.168.1.100 (example)", text: $inputConnectionData.consoleIP)
                            Button {
                                print("Button was tapped")
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }
                        }
                        HStack{
                            Text("RPI Port")
                            TextField("12800 (default)", text: $inputConnectionData.consolePort)
                            Button {
                                print("Button was tapped")
                            } label: {
                                Image(systemName: "questionmark.circle")
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
                
                swiftStartServer(serverIP: connection.serverIP, serverPort: connection.serverPort)
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Important message"), message: Text(alertText), dismissButton: .default(Text("Got it!")))
            }
            
            /*ServerStatusView(serverStatus: $connection.connectionStatus)
                .frame(height: 40)
                .onAppear(perform: {
                    DispatchQueue.global(qos: .background).async {
                        while(true){
                            autoreleasepool{
                                let status = checkIfServerIsWorking(serverIP: connection.serverIP, serverPort: connection.serverPort)
                                DispatchQueue.main.async {
                                    connection.connectionStatus = status
                                }
                            }
                            sleep(2)
                            
                        }
                    }
                })*/
        }
    }
}



struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
            .environmentObject(ConnectionDetails())
    }
}

