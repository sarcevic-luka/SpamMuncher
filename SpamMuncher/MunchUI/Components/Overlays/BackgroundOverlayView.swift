//
//  BackgroundOverlayView.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

/// A semi-transparent overlay view with custom content. It dismisses itself when tapped outside the content.
public struct BackgroundOverlayView<Content: View>: View {
    @Binding public var isPresented: Bool
    public let content: Content
    
    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        _isPresented = isPresented
        self.content = content()
    }
    
    public var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    isPresented = false
                }
            }
            .overlay(content)
    }
}
