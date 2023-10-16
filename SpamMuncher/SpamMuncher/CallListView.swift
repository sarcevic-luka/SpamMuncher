//
//  CallListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI
import MunchUI

struct CallListView: View {
    typealias FilterType = CallListViewModel.FilterType
    
    @ObservedObject var viewModel: CallListViewModel
    
    var body: some View {
        ZStack {
            backgroundGradient
            mainContent
            if viewModel.isPhoneNumberPopupVisible {
                phoneNumberPopup
            }
        }
    }
}

// MARK: - Private Views

private extension CallListView {
    var backgroundGradient: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [.gray, .lightPrimary]), startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            .zIndex(0)
    }
    
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
            phoneNumber: $viewModel.enteredPhoneNumber,
            isValid: $viewModel.isPhoneNumberValid,
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


struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("Search", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
}

struct CallListView_Previews: PreviewProvider {
    static var previews: some View {
        CallListView(viewModel: CallListViewModel())
    }
}
