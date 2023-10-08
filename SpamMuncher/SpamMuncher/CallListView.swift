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
            FilterPicker
            List(viewModel.filteredCalls) { call in
                NavigationLink(destination: CallRowView(call: call)) {
                    CallRowView(call: call)
                }
            }
        }
    }
    
    var FilterPicker: some View {
        Picker("Filter by type", selection: $viewModel.selectedFilterType) {
            Text("None").tag(FilterType.none)
            Text("Normal").tag(FilterType.normal)
            Text("Suspicious").tag(FilterType.suspicious)
            Text("Scam").tag(FilterType.scam)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
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
