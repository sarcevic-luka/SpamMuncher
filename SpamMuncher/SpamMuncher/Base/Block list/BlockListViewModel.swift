//
//  BlockListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import Foundation
import SwiftUI
import MunchUI
import MunchCallDirectory
import CallKit

final class BlockListViewModel: ObservableObject {
    enum FilterType: String, CaseIterable {
        case all = "ALL"
        case blocked = "Blocked"
        case suspicious = "Suspicious"

        var phoneNumberType: PhoneNumberType? {
            switch self {
            case .all:
                return nil
            case .blocked:
                return .blocked
            case .suspicious:
                return .suspicious
            }
        }
    }

    @Published var searchText: String = ""
    @Published var selectedFilterType: FilterType = .all

    @Published var isPhoneNumberPopupVisible: Bool = false
    @Published var enteredPhoneNumber: String = ""
    @Published var isPhoneNumberValid: Bool? = nil
    @Published var phoneNumberPopupViewModel = PhoneNumberPopupViewModel()

    var filteredContacts: [PhoneNumber] {
        let phoneNumberManager = PhoneNumberManager.shared
        let allContacts: [PhoneNumber]

        switch selectedFilterType.phoneNumberType {
        case .blocked:
            allContacts = phoneNumberManager.blockedNumbers
        case .suspicious:
            allContacts =  phoneNumberManager.suspiciousNumbers
        case nil:
            allContacts =  phoneNumberManager.blockedNumbers + phoneNumberManager.suspiciousNumbers
        }
        
        if !searchText.isEmpty {
            return allContacts.filter { contact in
                contact.number.description.contains(searchText) || contact.label.contains(searchText)
            }
        } else {
            return allContacts
        }

    }

    private let phoneNumberManager = PhoneNumberManager.shared

    func checkPhoneNumberValidity() {
        // Check if entered phone number is valid, you can adjust this logic.
        print("enteredPhoneNumber: " ,enteredPhoneNumber)
        isPhoneNumberValid = enteredPhoneNumber.range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }

    func addPhoneNumber() {
        if isPhoneNumberValid == true, let validNumber = Int64(enteredPhoneNumber) {

            let newPhoneNumber = PhoneNumber(id: validNumber, number: validNumber, label: phoneNumberPopupViewModel.selectedNumberType.rawValue.capitalized)
            phoneNumberManager.addNumber(newPhoneNumber, type: phoneNumberPopupViewModel.selectedNumberType)
            
            withAnimation {
                isPhoneNumberPopupVisible = false
            }
            enteredPhoneNumber = ""
            isPhoneNumberValid = nil
        }
    }

    private func refreshCallDirectory() {
        let directoryHandler = CallDirectoryHandler()
        // Create a context for the handler (assuming you have an extension context available)
        let context = CXCallDirectoryExtensionContext()
        directoryHandler.beginRequest(with: context)
    }

    func togglePhoneNumberPopup() {
        withAnimation {
            isPhoneNumberPopupVisible.toggle()
            phoneNumberPopupViewModel.phoneNumber = self.enteredPhoneNumber
        }
    }
    
    func handleAddPhoneNumber() {
        self.enteredPhoneNumber = phoneNumberPopupViewModel.phoneNumber
        checkPhoneNumberValidity()
        if isPhoneNumberValid == true {
            addPhoneNumber()
        }
    }
}
