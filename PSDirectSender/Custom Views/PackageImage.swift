//
//  PackageImage.swift
//  PSDirectSender
//
//  Created by Macintosh on 16.06.2022.
//

import SwiftUI

struct Squircle: ViewModifier {
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    let strokeColor: Color
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(strokeColor, lineWidth: lineWidth)
            )
    }
}

extension Image {
    func squircle(cornerRadius: CGFloat, lineWidth: CGFloat, strokeColor: Color) -> some View {
        self.modifier(Squircle(cornerRadius: cornerRadius, lineWidth: lineWidth, strokeColor: strokeColor))
    }
}

fileprivate extension Image {
    /// Initializes a SwiftUI `Image` from data.
    init?(data: Data) {
        if let nsImage = NSImage(data: data) {
            self.init(nsImage: nsImage)
        } else {
            return nil
        }
    }
}

struct PackageImage: View {
    @State var imageData: Data?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            if let imageData = imageData, let image = Image(data: imageData) {
                image
                    .resizable()
                    .squircle(cornerRadius: 10, lineWidth: 3, strokeColor: /*colorScheme == .light ? Color(red: 170, green: 170, blue: 170) : .gray*/ .clear)
            } else {
                Image(systemName: "shippingbox")
                    .resizable()
                    .frame(width: 55)
            }
        }
        .frame(width: 60, height: 60)
        .opacity(0.9)
    }
}

struct PackageImage_Previews: PreviewProvider {
    @EnvironmentObject var connection: ConnectionDetails

    static var previews: some View {
        let image = NSImage(named: NSImage.Name("TestPackageIcon"))?.tiffRepresentation
        
        PackageImage(
            imageData: image
        )

        let view = QueueView(packages: [
            Package(url: URL(string: "https://example.com/game.pkg")!, imageData: image),
            Package(url: URL(string: "https://example.com/dlc.pkg")!, imageData: image, state: .sendSuccess),
            Package(url: URL(string: "https://example.com/dlc.pkg")!, state: .sendFailure)
        ]).environmentObject(ConnectionDetails())
        
        view
    }
}
