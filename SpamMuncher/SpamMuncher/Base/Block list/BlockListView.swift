//
//  BlockListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI
import MunchUI

struct BlockListView: View {
    @ObservedObject var viewModel: BlockListViewModel

    var body: some View {
            ZStack {
                BackgroundGradientView()
                mainContent
                if viewModel.isPhoneNumberPopupVisible {
                    phoneNumberPopup
                }
            }
        .navigationBarTitle("BlockList", displayMode: .inline)
        .navigationBarItems(trailing: addButton)
    }
}

// MARK: - Private Views

private extension BlockListView {
    var mainContent: some View {
        GeometryReader { geometry in
            VStack {
                SearchBar(searchText: $viewModel.searchText)
                if viewModel.filteredContacts.isEmpty && !viewModel.searchText.isEmpty {
                    Spacer(minLength: 0)
                    InfoView(imageName: "magnifyingglass", message: "No numbers found for \"\(viewModel.searchText)\"")
                        .frame(maxHeight: geometry.size.height - 44)
                    Spacer(minLength: 0)
                } else {
                    segmentedControl
                    blockedContactsList
                }
            }
        }
    }

    var segmentedControl: some View {
        AdaptiveTextSegmentedScrollControl(selectedValue: $viewModel.selectedFilterType)
            .padding(.horizontal, 0)
            .zIndex(1)
    }

    var blockedContactsList: some View {
        List(viewModel.filteredContacts) { contact in
            ContactRowView(contact: contact)
        }
        .listRowBackground(Color.clear)
        .listStyle(PlainListStyle())
    }

    var addButton: some View {
        Button(action: {
            viewModel.togglePhoneNumberPopup()
        }) {
            Image(systemName: "plus")
                .foregroundColor(.secondary) 
                .font(.system(size: 20))
        }
        .padding()
    }

    var phoneNumberPopup: some View {
        PhoneNumberPopup(
            isPresented: $viewModel.isPhoneNumberPopupVisible,
            viewModel: viewModel.phoneNumberPopupViewModel,
            onAdd: viewModel.handleAddPhoneNumber
        )
    }
}

struct ContactRowView: View {
    let contact: PhoneNumber

    var body: some View {
        HStack {
            Text(contact.number.description)
            Spacer()
            Text(contact.label)
        }
        .listRowBackground(Color.clear)
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
    }
}

// MARK: - Previews

struct BlockListView_Previews: PreviewProvider {
    static var previews: some View {
        BlockListView(viewModel: BlockListViewModel())
    }
}
