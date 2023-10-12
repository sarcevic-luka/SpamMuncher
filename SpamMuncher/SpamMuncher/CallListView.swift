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
            Rectangle()
                .fill(Gradient(colors: [.gray, .lightPrimary]))
                .ignoresSafeArea()
                .zIndex(0)
            VStack {
                SearchBar(searchText: $viewModel.searchText)
                AdaptiveTextSegmentedScrollControl(selectedValue: $viewModel.selectedFilterType)
                    .padding(.horizontal, 0)
                    .zIndex(1)
                List(viewModel.filteredCalls) { call in
                    CallRowView(call: call)
                }
                .listRowBackground(Color.clear)
                .listStyle(PlainListStyle())
                .background(Color.clear)
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
