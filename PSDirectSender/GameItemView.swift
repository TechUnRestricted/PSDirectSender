//
//  GameItemView.swift
//  PSDirectSender
//
//  Created by Macintosh on 06.03.2022.
//

import SwiftUI

enum GameState: String{
    case paused = "play"
    case uploading = "pause"
    case done = "checkmark"
    case unknown = "questionmark"
}

struct GameItemView: View{
    let id = UUID()

    @Environment(\.colorScheme) var colorScheme

    @State var state : GameState
    let packageName : String?
    let packagePath : String
    
    var body: some View{
        HStack(spacing: 5){
            
            Image(systemName: state.rawValue)
                .font(.system(size: 35))
                .padding(20)
                .frame(width:70)
                .opacity(0.95)

                
            VStack(alignment: .leading){
                Text(packageName ?? "Package File")
                    .bold()
                    .font(.title2)
                    .opacity(0.95)

                Text(packagePath)
                    .font(.subheadline)
                    .opacity(0.5)

            }
        }
        .frame(maxWidth: .infinity, minHeight: 70, alignment: .leading)
        .background(colorScheme == .light ? Color.white : Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1)
        .lineLimit(1)

    }
}
