//
//  AppleSupportPopupView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI
import MunchUI

struct AppleSupportPopupView: View {
    @Binding var isPresented: Bool
    @Environment(\.openURL) private var openURL
    let title: String
    let description: String
    
    var body: some View {
        BackgroundOverlayView(isPresented: $isPresented) {
            mainContent
        }
    }
}

// MARK: - Private Views

private extension AppleSupportPopupView {
    var mainContent: some View {
        VStack(spacing: 20) {
            header
            descriptionText
            actionButtons
        }
        .padding(20)
        .background(Color.charcoalGray)
        .cornerRadius(15)
        .offset(y: -50)
    }
    
    var header: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
    
    var descriptionText: some View {
        Text(description)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
    }
    
    var actionButtons: some View {
        HStack(spacing: 20) {
            supportButton
            dismissButton
        }
    }
    
    var supportButton: some View {
        Button(action: {
            if let url = URL(string: "https://support.apple.com/en-us/HT207099?cid=ytsc_yt1298") {
                openURL(url)
            }
        }, label: {
            Text("Visit Apple Support")
        })
        .customStyle(.primary)
    }
    
    var dismissButton: some View {
        Button(action: {
            isPresented = false
        }, label: {
            Text("Dismiss")
        })
        .customStyle(.secondary)
    }
}

// MARK: - Previews

struct AppleSupportPopupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppleSupportPopupView(
                isPresented: .constant(true),
                title: "Apple Support",
                description: "Would you like to visit Apple Support to read about 'Turn on Silence Unknown Callers'?"
            )
            .background(Color.gray.opacity(0.5))
            
            AppleSupportPopupView(
                isPresented: .constant(true),
                title: "Another Title",
                description: "Another description for testing purposes."
            )
            .background(Color.black.opacity(0.5))
        }
        .previewLayout(.sizeThatFits)
    }
}
