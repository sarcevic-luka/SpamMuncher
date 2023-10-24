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

    var isAddButtonDisabled: Bool {
        phoneNumber.isEmpty
    }
    
    func validateAndAddPhoneNumber(onAdd: () -> Void) {
        checkPhoneNumberValidity()
        
        if isValid == true {
            onAdd()
        }
    }
    
    private func checkPhoneNumberValidity() {
        // Check if entered phone number is valid using a regex
        isValid = phoneNumber.range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }
}
