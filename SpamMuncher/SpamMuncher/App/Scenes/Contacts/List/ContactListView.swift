//
//  ContactListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI
import MunchUI

struct ContactListView: View {
    @ObservedObject var viewModel: ContactListViewModel
    
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
            .onAppear(perform: viewModel.requestContactPermissions)
        }
    }
    
    private var mainContent: some View {
        Group {
            switch viewModel.infoViewState {
            case .hidden:
                contactsList
            case .noContactsPermissionGranted, .noContacts:
                InfoView(state: viewModel.infoViewState)
            default:
                EmptyView()
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
        ForEach(viewModel.contacts()[key]!, id: \.id) { contact in
            let contactDetailVM = ContactDetailViewModel(contact: contact, phoneNumberManager: viewModel.phoneNumberManager)
            contactRow(for: contact, with: contactDetailVM)
        }
    }

    func contactRow(for contact: Contact, with viewModel: ContactDetailViewModel) -> some View {
        NavigationLink(destination: ContactDetailView(viewModel: viewModel)) {
            HStack {
                if viewModel.isContactBlocked {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 5)
                }
                Text(contact.name)
            }
        }
        .listRowBackground(Color.clear)
    }
}
