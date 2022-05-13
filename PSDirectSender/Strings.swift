//
//  Strings.swift
//  PSDirectSender
//
//  Created by Macintosh on 11.05.2022.
//

import SwiftUI

class MessageCollection {
    
    let cantGetServerConfiguration: LocalizedStringKey = """
Network connection was not detected.

If there is a connection, then specify the IP address of your network card and any port in the Configuration section.
"""
    
    let cantGetConsoleConfiguration: LocalizedStringKey = """
Console connection configuration data is missing.

Go to the Configuration section and correctly fill in the text fields.
"""
    
    let cantGetResponseFromConsole: LocalizedStringKey = """
No response received from Remote Package Installer.

Make sure the data you entered in the Configuration section is correct and the Remote Package Installer application is active.
As a last resort, restart your console and try sending again.
"""
    
    let serverIPHelp: LocalizedStringKey = """
This field is usually filled in automatically by the program.
It specifies the IP address of one of your network cards (Wi-Fi, Ethernet) on your Mac.

If this field was not filled in automatically, make sure that your computer is connected to the local network.
You can select the IP address of one of your network cards by clicking on the down arrow in the text field.
The IP address can also be found by going to [System Preferences -> Network -> (Device) -> IP Address]
"""
    
    let serverPortHelp: LocalizedStringKey = """
This field is usually filled in automatically by the program.
If this field was not filled in automatically, make sure that your computer is connected to the local network.

You can specify any value between 0 and 65536, however, some ports may be busy/reserved for other applications.
"""
    
    let consoleIPHelp: LocalizedStringKey = """
This field must be filled in manually.

On your console go to the [Settings -> Network -> View Connection Status].
Find the IP Address entry and enter it into this field.
"""
    
    let consolePortHelp: LocalizedStringKey = """
This value set by default and should not be changed without special reason.
    
Points to the port used by the Remote Package Installer application on your console.
"""
}
