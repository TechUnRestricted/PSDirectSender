//
//  ColorButton.swift
//  PSDirectSender
//
//  Created by Macintosh on 29.04.2022.
//

import SwiftUI

struct ColorButton: View{
    let text : String
    let color : Color
    let image : Image
    var handler: () -> ()
    
    var body: some View {
        Button(action: {
            handler()
        }, label: {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text(text).font(.title3)
        }).buttonStyle(ColorButtonStyle(color: color.opacity(0.8)))
            .frame(minWidth: 100, maxWidth: 200, maxHeight: 40)
    }
}

struct ColorButtonStyle: ButtonStyle {
    var color : Color
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label.foregroundColor(colorScheme == .light ? .black : .white).opacity(0.8)
            Spacer()
        }
        .ignoresSafeArea()
        .padding()
        .background(color.cornerRadius(15))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        //.animation(.easeInOut, value: configuration.isPressed)
    }
}

struct ColorButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            HStack{
                Image(systemName: "trash")
                Text("Delete")
            }.font(.title2)
        }).buttonStyle(ColorButtonStyle(color: .red.opacity(0.5)))
            .frame(width: 200)
        
        ColorButton(text: "Add", color: .orange, image:                 Image(systemName: "plus.rectangle.on.rectangle"), handler: {})
    }
}
