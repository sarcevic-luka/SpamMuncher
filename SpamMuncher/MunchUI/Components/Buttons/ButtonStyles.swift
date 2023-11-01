//
//  ButtonStyles.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

public struct ButtonStyling {
    let backgroundColor: Color
    let textColor: Color

    public static let primary = ButtonStyling(backgroundColor: .black, textColor: .sunnyYellow)
    public static let secondary = ButtonStyling(backgroundColor: .crimsonRed, textColor: .charcoalGray)
}

public struct CustomButtonStyle: ButtonStyle {
    let style: ButtonStyling
    @Environment(\.isEnabled) private var isEnabled: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isEnabled ? style.backgroundColor : style.backgroundColor.opacity(0.3))
            .foregroundColor(isEnabled ? style.textColor : style.textColor.opacity(0.3))
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)

    }
}

public extension Button {
    func customStyle(_ style: ButtonStyling) -> some View {
        self.buttonStyle(CustomButtonStyle(style: style))
    }
}
