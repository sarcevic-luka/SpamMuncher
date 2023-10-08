//
//  CallListView.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI

struct CallListView: View {
    @ObservedObject var viewModel: CallListViewModel
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
            picker
            List(viewModel.filteredCalls) { call in
                NavigationLink(destination: CallRowView(call: call)) {
                    CallRowView(call: call)
                }
            }
        }
    }
    
    var picker: some View {
        Picker("Filter by type", selection: $viewModel.selectedCallType) {
            Text("None").tag(nil as Call.CallType?)
            Text("Normal").tag(Call.CallType.normal)
            Text("Suspicious").tag(Call.CallType.suspicious)
            Text("Scam").tag(Call.CallType.scam)
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
