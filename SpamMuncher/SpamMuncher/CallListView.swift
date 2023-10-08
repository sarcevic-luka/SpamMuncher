//
//  CallListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI

struct CallListView: View {
    typealias FilterType = CallListViewModel.FilterType
    
    @ObservedObject var viewModel: CallListViewModel
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
            CustomSegmentedControl(selectedValue: $viewModel.selectedFilterType)
                .padding(.horizontal, 0)
            List(viewModel.filteredCalls) { call in
                NavigationLink(destination: CallRowView(call: call)) {
                    CallRowView(call: call)
                }
            }
        }
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


extension Color {
    static let primaryColor = Color.gray
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)

}
