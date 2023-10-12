//
//  SpamMuncherApp.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI

@main
struct SpamMuncherApp: App {
    @StateObject var callListViewModel = CallListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CallListView(viewModel: CallListViewModel())
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .preferredColorScheme(.dark)
        }
    }
}

