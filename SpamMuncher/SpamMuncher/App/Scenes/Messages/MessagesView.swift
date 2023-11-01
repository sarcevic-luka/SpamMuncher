//
//  MessagesView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI
import MunchUI

struct MessagesView: View {
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradientView()
                InfoView(state: .underConstruction)
            }
            .navigationBarTitle("Messages", displayMode: .inline)
        }
    }
}
