//
//  InfoView.swift
//  MunchUI
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

import SwiftUI

public struct InfoView: View {
    public enum InfoViewState {
        case underConstruction
        case noNumbersFound(searchText: Binding<String>)
        case noNumbersAdded(filterText: String)
        case noContactsPermissionGranted
        case noContacts
        case hidden
        
        fileprivate var details: (imageName: String, message: String) {
            switch self {
            case .underConstruction:
                return ("hammer.fill", "Under Construction")
            case .noNumbersFound(let binding):
                return ("magnifyingglass", "No numbers found for \(binding.wrappedValue)")
            case .noNumbersAdded(let filterText):
                return ("plus.circle", "No numbers currently added for \(filterText)")
            case .noContactsPermissionGranted:
                return ("lock.fill", "Please allow access to contacts in Settings")
            case .noContacts:
                return ("xmark.circle", "No Contacts Available")
            case .hidden:
                return ("", "")
            }
        }
    }
    
    private var imageName: String
    private var message: String
    private var state: InfoViewState
    
    public init(state: InfoViewState) {
        self.state = state
        
        let details = state.details
        self.imageName = details.imageName
        self.message = details.message
    }
    
    public var body: some View {
        Group {
            if case .hidden = state {
                EmptyView()
            } else {
                
                VStack(spacing: 16) {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    Text(message)
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.lowLightColor)
                .padding(.horizontal)
            }
        }
    }
}
