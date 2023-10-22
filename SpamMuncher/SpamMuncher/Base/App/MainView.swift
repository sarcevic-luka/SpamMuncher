//
//  MainView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI
import MunchUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                BlockListView(viewModel: BlockListViewModel())
            }
            .tabItem {
                Label("BlockList", systemImage: "shield.fill")
            }
            ContactsView()
                .tabItem {
                    Label("Contacts", systemImage: "person.fill")
                }

            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
        }
        .accentColor(.alertColor)
    }
}
