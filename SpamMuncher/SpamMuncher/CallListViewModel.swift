//
//  CallListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import Foundation
import SwiftUI
import MunchUI

final class CallListViewModel: ObservableObject {
    enum FilterType: String, CaseIterable {
        case none = "ALL"
        case normal = "Normal"
        case suspicious = "Suspicious"
        case scam = "Scam"
        
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

    // Search variables
    @Published var searchText: String = ""
    @Published var selectedFilterType: FilterType = .none

    // State for PhoneNumberPopup
    @Published var isPhoneNumberPopupVisible: Bool = false
    @Published var enteredPhoneNumber: String = ""
    @Published var isPhoneNumberValid: Bool? = nil
    @Published var phoneNumberPopupViewModel = PhoneNumberPopupViewModel()

    var filteredCalls: [Call] {
        callListModel.filterCalls(by: searchText, selectedCallType: selectedFilterType.callType)
    }

    private var callListModel: CallListModel = createCallListModel()

    func checkPhoneNumberValidity() {
        // Check if entered phone number is valid, you can adjust this logic.
        isPhoneNumberValid = enteredPhoneNumber.range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }

    func addPhoneNumber() {
        if isPhoneNumberValid == true {
            // Add the phone number to your list or perform other operations.
            // Example: add to a list
//            let newCall = Call(callerName: "New Caller", callerNumber: enteredPhoneNumber, callType: .normal, timestamp: Date())
//            callListModel.incomingCalls.append(newCall)
            
            // Close the popup
            withAnimation {
                isPhoneNumberPopupVisible = false
            }
            enteredPhoneNumber = ""
            isPhoneNumberValid = nil
        }
    }

    func togglePhoneNumberPopup() {
        withAnimation {
            isPhoneNumberPopupVisible.toggle()
        }
    }
    
    func handleAddPhoneNumber() {
        checkPhoneNumberValidity()
        if isPhoneNumberValid == true {
            addPhoneNumber()
        }
    }

    // TODO: create Dependency Injection for CallListModel
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
