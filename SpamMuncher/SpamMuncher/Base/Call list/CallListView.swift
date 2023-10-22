//
//  CallListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI
import MunchUI

struct CallListView: View {
    @ObservedObject var viewModel: CallListViewModel
    
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

private extension CallListView {
    var mainContent: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
            segmentedControl
            callsList
            addButton
        }
    }
    
    var segmentedControl: some View {
        AdaptiveTextSegmentedScrollControl(selectedValue: $viewModel.selectedFilterType)
            .padding(.horizontal, 0)
            .zIndex(1)
    }
    
    var callsList: some View {
        List(viewModel.filteredCalls) { call in
            CallRowView(call: call)
        }
        .listRowBackground(Color.clear)
        .listStyle(PlainListStyle())
    }
    
    var addButton: some View {
        Button("Add Phone Number") {
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

struct CallRowView: View {
    let call: Call
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(call.callerName)
                Text(call.callerNumber)
            }
            Spacer()
            Text(call.callType.description)
                .foregroundColor(call.callType.textColor)
            Text(call.callTime)
        }
        .listRowBackground(Color.clear)
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
    }
}

// MARK: - Previews

struct CallListView_Previews: PreviewProvider {
    static var previews: some View {
        CallListView(viewModel: CallListViewModel())
    }
}
