//
//  QueueView.swift
//  PSDirectSender
//
//  Created by Macintosh on 06.03.2022.
//

import SwiftUI
struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 120, height: 40)
            .background(Color.blue.opacity(0.9))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}



struct QueueView: View{
    @State var currentQueueList : [GameItemView] = [GameItemView(state: .paused, packageName: "The First of Them Part IV", packagePath: "/Volumes/Macintosh HD/Users/Name/[CUSA00000] The First of Them Part IV.pkg")]
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Button{
                    print("Add button was tapped")
                    currentQueueList.insert(GameItemView(state: .paused, packageName: "The First of \(arc4random())", packagePath: "/Volumes/Macintosh HD/Users/Name/[CUSA\(arc4random())] The First of Them Part IV.pkg"), at: 0)
                } label: {
                    HStack{
                        Text("Add")
                        Image(systemName: "plus.app")
                    }
                }.buttonStyle(BlueButton())
                    
            }.padding(.bottom, 10)

            
            LazyVStack(spacing: 10){
                ForEach(currentQueueList, id: \.id){ item in
                    item
                }
            }
            Text("You can drag'n'drop multiple .pkgs to this window.")
                .opacity(0.5)
                .padding()
        }.padding()
        
        /*
         
         //FIXME: Toolbar Item causing crashes when switching between screens while resizing the window
         
         .toolbar {
         ToolbarItem() {
         Button(action: {
         
         }, label: {
         Image(systemName: "plus.app")
         })
         }
         }
         */
    }
}

struct GameItem_Previews: PreviewProvider {
    static var previews: some View {
        QueueView()
        GameItemView(state: .paused, packageName: "The First of Them Part IV", packagePath: "/Volumes/Macintosh HD/Users/Name/[CUSA00000] The First of Them Part IV.pkg")
            .frame(width: 570)
            .padding()
    }
}
