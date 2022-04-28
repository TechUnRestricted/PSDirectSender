//
//  ContentView.swift
//  PSDirectSender
//
//  Created by Macintosh on 22.04.2022.
//

import SwiftUI

enum Screen: String, CaseIterable{
    case queue
    case configuration
    case logs
    case info
}

struct ContentView: View {
    @State var currentScreen : Screen? = .queue
    @State var currentTab : Screen = .queue
    
    var body: some View {
        NavigationView(){
            List(selection: $currentScreen){
                Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                    .opacity(0.8)
                    .frame(maxWidth: .infinity)
                Text("Navigation")
                    .font(.subheadline)
                ForEach(Screen.allCases, id: \.self) { screen in
                    SidebarButton(type: screen)
                }
            }.onChange(of: currentScreen!){ action in
                currentTab = action
            }
            .listStyle(SidebarListStyle())
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        toggleSidebar()
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
            }
            .frame(minWidth: 180)
            
            TabView(selection: $currentTab){
                ForEach(Screen.allCases, id: \.self) { screen in
                    ScreenView(screen: screen)
                        .tag(screen)
                }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
