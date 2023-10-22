//
//  InfoView.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

public struct InfoView: View {
    public var imageName: String
    public var message: String
    
    public init(imageName: String, message: String) {
        self.imageName = imageName
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            Text(message)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.lowLightColor)
        .padding(.horizontal)
    }
}
