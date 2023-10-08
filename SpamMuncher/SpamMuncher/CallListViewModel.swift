//
//  CallListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import Foundation
import SwiftUI

final class CallListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCallType: Call.CallType? = nil

    public var filteredCalls: [Call] {
        print("Selected type: ", selectedCallType as Call.CallType? ?? "None")
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

    private var incomingCalls: [Call]

    init() {
        // TODO: Move this to a database
        self.incomingCalls = [
                                                    Call(callerName: "Mika", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Zika", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Laza", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Pera", callerNumber: "425-950-1212", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Mika", callerNumber: "253-950-1212", callType: .scam, timestamp: Date()),
                                                    Call(callerName: "Zika", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Laza", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Pera", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Mika", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Zika", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Laza", callerNumber: "098889898", callType: .suspicious, timestamp: Date()),
                                                    Call(callerName: "Pera", callerNumber: "098889898", callType: .scam, timestamp: Date()),
                                                    Call(callerName: "Mika", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Zika", callerNumber: "098889898", callType: .suspicious, timestamp: Date()),
                                                    Call(callerName: "Laza", callerNumber: "098889898", callType: .normal, timestamp: Date()),
                                                    Call(callerName: "Pera", callerNumber: "098889898", callType: .scam, timestamp: Date()),
                                                    Call(callerName: "Mika", callerNumber: "098889898", callType: .normal, timestamp: Date()) ]
    }
}
