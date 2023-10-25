//
//  BlockListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI
import MunchUI

struct BlockListView: View {
    @ObservedObject private var viewModel: BlockListViewModel

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradientView()
                mainContent
                if viewModel.isPhoneNumberPopupVisible {
                    phoneNumberPopup
                }
            }
            .navigationBarTitle("BlockList", displayMode: .inline)
            .searchable(text: $viewModel.searchText)
            .navigationBarItems(trailing: addButton)
        }
    }
    
    init(viewModel: BlockListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Private Views

private extension BlockListView {
    var mainContent: some View {
        GeometryReader { geometry in
            VStack {
                segmentedControl
                switch viewModel.infoViewState {
                case .hidden:
                    blockedContactsList
                case .noNumbersFound, .noNumbersAdded:
                    Spacer(minLength: 0)
                    InfoView(state: viewModel.infoViewState)
                        .frame(maxHeight: geometry.size.height - 44)
                    Spacer(minLength: 0)
                default:
                    EmptyView()
                }
            }
        }
    }

    @ViewBuilder
    func infoView(for content: GeometryProxy) -> some View {
        Spacer(minLength: 0)
        InfoView(state: .noNumbersFound(searchText: $viewModel.searchText))
            .frame(maxHeight: content.size.height - 44)
        Spacer(minLength: 0)
    }

    var segmentedControl: some View {
        AdaptiveTextSegmentedScrollControl(selectedValue: $viewModel.selectedFilterType)
            .padding(.horizontal, 0)
            .zIndex(1)
    }

    var blockedContactsList: some View {
        List(viewModel.contacts) { contact in
            ContactRowView(contact: contact) {
                viewModel.deleteContact(contact: contact)
            }
        }
        .listRowBackground(Color.clear)
        .listStyle(PlainListStyle())
    }

    var addButton: some View {
        Button(action: {
            viewModel.togglePhoneNumberPopup()
        }) {
            Image(systemName: "plus")
                .foregroundColor(.alertColor) 
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

// MARK: - Previews

struct BlockListView_Previews: PreviewProvider {
    static var previews: some View {
        BlockListView(viewModel: BlockListViewModel.mock)
    }
}
