//
//  CallListModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import Foundation

struct CallListModel {
    typealias CallType = Call.CallType
    
    private(set) var filteredCards: [Call] = []
    private(set) var searchText: String = ""
    private(set) var selectedCallType: CallType? = nil
    private let incomingCalls: [Call]

    init(incomingCalls: [Call]) {
        self.incomingCalls = incomingCalls
    }
    
    func filterCalls(by searchText: String, selectedCallType: CallType?) -> [Call] {
        var filtered = incomingCalls

        if let callType = selectedCallType {
            filtered = filtered.filter { $0.callType == callType }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter { $0.callerName.localizedCaseInsensitiveContains(searchText) ||
                $0.callerNumber.localizedCaseInsensitiveContains(searchText)
            }
        }

        return filtered
    }
}
