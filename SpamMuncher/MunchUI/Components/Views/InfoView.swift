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
        case error(message: String)
        
        fileprivate var details: (imageName: String, message: String) {
            switch self {
            case .underConstruction:
                return ("hammer.fill", NSLocalizedString("UnderConstruction", bundle: Bundle.munchUIBundle, comment: ""))
            case .noNumbersFound(let binding):
                let localizedMessage = String(format: NSLocalizedString("NoNumbersFound", bundle: Bundle.munchUIBundle, comment: ""), binding.wrappedValue)
                return ("magnifyingglass", localizedMessage)
            case .noNumbersAdded(let filterText):
                let localizedMessage = String(format: NSLocalizedString("NoNumbersAdded", bundle: Bundle.munchUIBundle, comment: ""), filterText)
                return ("plus.circle", localizedMessage)
            case .noContactsPermissionGranted:
                return ("lock.fill", NSLocalizedString("NoContactsPermission", bundle: Bundle.munchUIBundle, comment: ""))
            case .noContacts:
                return ("xmark.circle", NSLocalizedString("NoContactsAvailable", bundle: Bundle.munchUIBundle, comment: ""))
            case .error(let message):
                return ("exclamationmark.triangle.fill", message)
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
                .foregroundColor(.deepBlack)
                .padding(.horizontal)
            }
        }
    }
}
