//
//  ContentView.swift
//  PSDirectSender
//
//  Created by Macintosh on 05.03.2022.
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
    var body: some View {
        NavigationView(){
            List(selection: $currentScreen){
                Text("Navigation")
                    .font(.subheadline)
                ForEach(Screen.allCases, id: \.self) { screen in
                    NavigationLink(destination: ScreenView(screen: currentScreen ?? .queue)) {
                        SidebarButton(type: screen)
                    }
                }
                Spacer()
                Text("PS4 Connection Status: 􀇺")
                    .lineLimit(2)
                    .font(.subheadline)

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
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
