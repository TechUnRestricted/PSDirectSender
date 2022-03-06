//
//  QueueView.swift
//  PSDirectSender
//
//  Created by Macintosh on 06.03.2022.
//

import SwiftUI


struct QueueView: View{
    var body: some View{
        VStack(spacing: 18){
            GameItemView(state: .paused, packageName: "The First of Them Part IV", packagePath: "/Volumes/Macintosh HD/Users/Name/[CUSA00000] The First of Them Part IV.pkg")
            GameItemView(state: .paused, packageName: "The First of Them Part IV", packagePath: "/Volumes/Macintosh HD/Users/Name/[CUSA00000] The First of Them Part IV.pkg")
            GameItemView(state: .paused, packageName: "The First of Them Part IV", packagePath: "/Volumes/Macintosh HD/Users/Name/[CUSA00000] The First of Them Part IV.pkg")
        }
        .padding()
        .toolbar {
            ToolbarItem() {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus.app")
                })
            }
        }
    }
}
struct GameItem_Previews: PreviewProvider {
    static var previews: some View {
        GameItemView(state: .paused, packageName: "The First of Them Part IV", packagePath: "/Volumes/Macintosh HD/Users/Name/[CUSA00000] The First of Them Part IV.pkg")
            .frame(width: 570)
            .padding()
    }
}
