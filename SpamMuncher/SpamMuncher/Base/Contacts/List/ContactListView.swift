//
//  ContactListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI
import MunchUI

struct ContactListView: View {
    @ObservedObject var viewModel: ContactsViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradientView()
                mainContent
            }
            .navigationBarTitle("Contacts", displayMode: .inline)
            .searchable(text: $viewModel.searchText)
            .onAppear(perform: viewModel.fetchContacts)
        }
    }
    
    private var mainContent: some View {
        Group {
            if viewModel.contacts().isEmpty && !viewModel.searchText.isEmpty {
                InfoView(imageName: "magnifyingglass", message: "No results found for \"\(viewModel.searchText)\"")
            } else {
                contactsList
            }
        }
    }
}

private extension ContactListView {
    var contactsList: some View {
        List {
            ForEach(viewModel.contacts().keys.sorted(), id: \.self) { key in
                Section(header: Text(String(key))) {
                    contactRows(for: key)
                }
            }
        }
        .listRowBackground(Color.clear)
        .listStyle(PlainListStyle())
    }

    func contactRows(for key: Character) -> some View {
        ForEach(viewModel.contacts()[key]!, id: \.phoneNumber) { contact in
            NavigationLink(destination: ContactDetailView(contact: contact)) {
                Text(contact.name)
            }
            .listRowBackground(Color.clear)
        }
    }
}
