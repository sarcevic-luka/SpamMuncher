//
//  ButtonStyles.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

public struct ButtonStyling {
    var backgroundColor: Color
    var textColor: Color

    public static let primary = ButtonStyling(backgroundColor: .black, textColor: .sunnyYellow)
    public static let secondary = ButtonStyling(backgroundColor: .crimsonRed, textColor: .charcoalGray)
}

public struct CustomButtonStyle: ButtonStyle {
    var style: ButtonStyling

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(style.backgroundColor)
            .foregroundColor(style.textColor)
            .cornerRadius(8)
    }
}

extension Button {
    public func customStyle(_ style: ButtonStyling) -> some View {
        self.buttonStyle(CustomButtonStyle(style: style))
    }
}
