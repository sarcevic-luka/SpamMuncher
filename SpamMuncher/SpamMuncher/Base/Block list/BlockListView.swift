//
//  CallListView.swift
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
    }
}

// MARK: - Private Views

private extension BlockListView {
    var mainContent: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
            segmentedControl
            blockedContactsList
            addButton
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
        Button("Add Blocked Contact") {
            viewModel.togglePhoneNumberPopup()
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