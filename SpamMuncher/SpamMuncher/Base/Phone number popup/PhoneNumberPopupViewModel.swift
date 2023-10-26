//
//  PhoneNumberPopupViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 21.10.2023..
//

import Foundation

class PhoneNumberPopupViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var isValid: Bool? = nil
    @Published var selectedNumberType: PhoneNumberType = .suspicious
    @Published var opacity: Double = 1

    private var phoneNumberManager: PhoneNumberManaging

    init(phoneNumberManager: PhoneNumberManaging) {
        self.phoneNumberManager = phoneNumberManager
    }

    var isAddButtonDisabled: Bool {
        phoneNumber.isEmpty
    }
    
    func addPhoneNumberAndClose(_ closeAction: () -> Void) {
        checkPhoneNumberValidity()

        if isValid == true {
            addPhoneNumber()
            closeAction()
        }
    }

    private func addPhoneNumber() {
        if let validNumber = Int64(phoneNumber) {
            let newPhoneNumber = PhoneNumber(id: validNumber, type: selectedNumberType)
            phoneNumberManager.addNumber(newPhoneNumber)
            phoneNumber = ""
            isValid = nil
        }
    }

    private func checkPhoneNumberValidity() {
        // For real app would probablt have more complex and accurate validation logic
        isValid = phoneNumber.range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }
}
