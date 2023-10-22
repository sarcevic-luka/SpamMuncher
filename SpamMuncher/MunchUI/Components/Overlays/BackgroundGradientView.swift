//
//  BackgroundGradientView.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

/// A background view with a top-to-bottom gradient.
public struct BackgroundGradientView: View {
    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [.gray, .lightPrimary]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            .zIndex(0)
    }
}
