//
//  Color.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import SwiftUI

extension Color {
    static let baseColor = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let primaryColor = baseColor.opacity(0.65)
    static let lightPrimary = primaryColor.opacity(0.2)
    static let highlightColor = Color(red: 0.98, green: 0.82, blue: 0.22)
    static let lowLightColor = Color(red: 0.75, green: 0.75, blue: 0.75)
    static let alertColor = Color(red: 0.98, green: 0.22, blue: 0.22)
    static let warningColor = Color(red: 0.98, green: 0.82, blue: 0.22)
}
