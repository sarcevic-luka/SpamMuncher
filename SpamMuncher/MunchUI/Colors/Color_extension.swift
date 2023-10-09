//
//  Color_extension.swift
//  MunchUI
//
//  Created by Code Forge on 09.10.2023..
//

import SwiftUI

extension Color {
    public static let baseColor = Color(red: 0.2, green: 0.2, blue: 0.2)
    public static let primaryColor = baseColor.opacity(0.65)
    public static let lightPrimary = primaryColor.opacity(0.2)
    public static let highlightColor = Color(red: 0.98, green: 0.82, blue: 0.22)
    public static let lowLightColor = Color(red: 0.75, green: 0.75, blue: 0.75)
    public static let alertColor = Color(red: 0.98, green: 0.22, blue: 0.22)
    public static let warningColor = Color(red: 0.98, green: 0.82, blue: 0.22)
}
