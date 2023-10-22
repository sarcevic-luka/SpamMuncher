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
                if viewModel.isAppleSupportPopupVisible {
                    withAnimation(.easeInOut) {
                        appleSupportPopup
                    }
                }
            }
            .navigationBarTitle("Contacts", displayMode: .inline)
            .navigationBarItems(trailing: supportButton)
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

    var supportButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                viewModel.isAppleSupportPopupVisible.toggle()
            }
        }) {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .padding()
    }

    var appleSupportPopup: some View {
        AppleSupportPopupView(
            isPresented: $viewModel.isAppleSupportPopupVisible,
            title: "Apple Support",
            description: "Would you like to visit Apple Support to read about 'Turn on Silence Unknown Callers'?"
        )
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
