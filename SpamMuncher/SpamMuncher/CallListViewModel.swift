//
//  CallListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import Foundation
import SwiftUI

final class CallListViewModel: ObservableObject {
    enum FilterType {
        case none
        case normal
        case suspicious
        case scam
        
        var callType: Call.CallType? {
            switch self {
            case .none:
                return nil
            case .normal:
                return .normal
            case .suspicious:
                return .suspicious
            case .scam:
                return .scam
            }
        }
    }

    @Published var searchText: String = ""
    @Published var selectedFilterType: FilterType = .none

    var filteredCalls: [Call] {
        callListModel.filterCalls(by: searchText, selectedCallType: selectedFilterType.callType)
    }

    private var callListModel: CallListModel = createCallListModel()

    private static func createCallListModel() -> CallListModel {
        let incomingCalls = [
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
        return CallListModel(incomingCalls: incomingCalls)
    }
}
