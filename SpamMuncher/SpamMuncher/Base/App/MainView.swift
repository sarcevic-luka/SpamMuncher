//
//  MainView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            BlockListView(viewModel: BlockListViewModel())
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
    }
}
