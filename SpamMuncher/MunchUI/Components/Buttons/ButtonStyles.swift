//
//  ButtonStyles.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

public struct ButtonStyling {
    var backgroundColor: Color
    var borderColor: Color
    var textColor: Color
    var borderWidth: CGFloat

    public static let primary = ButtonStyling(backgroundColor: .primaryColor, borderColor: .baseColor, textColor: .white, borderWidth: 0)
    public static let secondary = ButtonStyling(backgroundColor: .clear, borderColor: .baseColor, textColor: .baseColor, borderWidth: 2)
}

public struct CustomButtonStyle: ButtonStyle {
    var style: ButtonStyling

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(style.backgroundColor)
            .foregroundColor(style.textColor)
            .border(style.borderColor, width: style.borderWidth)
            .cornerRadius(8)
    }
}

extension Button {
    public func customStyle(_ style: ButtonStyling) -> some View {
        self.buttonStyle(CustomButtonStyle(style: style))
    }
}
