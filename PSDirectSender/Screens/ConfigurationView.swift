//
//  ConfigurationView.swift
//  PSDirectSender
//
//  Created by Macintosh on 06.03.2022.
//

import SwiftUI

func selectPackages() -> String?{
    let dialog = NSOpenPanel()

    dialog.title                   = "Choose PKGs"
    dialog.showsResizeIndicator    = true
    dialog.showsHiddenFiles        = false
    dialog.allowsMultipleSelection = true
    dialog.canCreateDirectories    = true
    dialog.allowedFileTypes = ["pkg"]
    dialog.canChooseDirectories = false;

    if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
        return dialog.url?.path
    }
    
    return nil
}

struct ConfigurationView: View{
    
    @State var consoleIPAddressTextField : String = ""
    @State var consoleRPIPortTextField : String = ""
    
    @State var webServerDirectoryTextField : String = ""
    @State var webServerDefaultPortTextField : String = ""
    
    @State var useBuiltInWebServerToggle : Bool = true
    
    var body: some View{
        VStack(spacing: 40){
            //TODO: Better UI Handling
            VStack(alignment: .leading){

                Group{
                    Text("Console IP Address: ")
                    TextField("IP", text: $consoleIPAddressTextField)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Group{
                    Text("RPI Port: ")
                    TextField("12800 (default)", text: $consoleRPIPortTextField)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            VStack(alignment: .leading){
                Group{
                    Text("Web Server Directory: ")
                    TextField("/ (default)", text: $webServerDirectoryTextField)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Group{
                    Text("Default Port: ")
                    TextField("19132 (default)", text: $webServerDefaultPortTextField)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            Toggle("Use Built-in Web Server", isOn: $useBuiltInWebServerToggle)
                .toggleStyle(CheckboxToggleStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .center){
            
                Button("Force Save and Restart"){
                    selectPackages()
                }
                Button("Reset to Default Settings"){}
            
            
            }
            
        }.padding()
    }
}
struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
