//
//  MainView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI
import MunchUI

struct MainView: View {
    let phoneNumberManager: PhoneNumberManaging = PhoneNumberManager()

    var body: some View {
        TabView {
            BlockListView(viewModel: BlockListViewModel(phoneNumberManager: phoneNumberManager))
                .tabItem {
                    Label("BlockList", systemImage: "shield.fill")
                }
            ContactListView(viewModel: ContactListViewModel(phoneNumberManager: phoneNumberManager))
                .tabItem {
                    Label("Contacts", systemImage: "person.fill")
                }

            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
        }
        .accentColor(.crimsonRed)
    }
}
