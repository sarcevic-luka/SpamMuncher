//
//  SearchBar.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

/// A simple search bar with a rounded border.
public struct SearchBar: View {
    @Binding public var searchText: String
    
    public init(searchText: Binding<String>) {
        _searchText = searchText
    }
    
    public var body: some View {
        TextField("Search", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
}
