//
//  ContentView.swift
//  PSDirectSender
//
//  Created by Macintosh on 05.03.2022.
//

import SwiftUI
import Introspect


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
                Text("Navigation")
                    .font(.subheadline)
                ForEach(Screen.allCases, id: \.self) { screen in
                        SidebarButton(type: screen)
                }
                Spacer()
                Text("PS4 Connection Status: 􀇺")
                    .lineLimit(2)
                    .font(.subheadline)

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
            TabView(selection: $currentTab){
                ForEach(Screen.allCases, id: \.self) { screen in
                    ScreenView(screen: screen)
                        .tag(screen)
                }
            }
            .introspectTabView{ property in
                            /* Using Introspect dependency
                             to disable TabView stock styling */
                            property.tabPosition = .none
                            property.tabViewBorderType = .none
                        }

            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
