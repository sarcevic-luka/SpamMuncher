//
//  PhoneNumberPopupViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 21.10.2023..
//

import Foundation
import Combine

class PhoneNumberPopupViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var isValid: Bool = false
    @Published var selectedNumberType: PhoneNumberType = .suspicious

    private var phoneNumberManager: PhoneNumberManaging

    init(phoneNumberManager: PhoneNumberManaging) {
        self.phoneNumberManager = phoneNumberManager
        setupBindings()
    }

    func addPhoneNumberAndClose(_ closeAction: @escaping () -> Void) {
        if isValid {
            let numericPhoneNumber = phoneNumber.filter { $0.isWholeNumber }
            if let validNumber = Int64(numericPhoneNumber) {
                phoneNumberManager.addNumber(PhoneNumber(id: validNumber, type: selectedNumberType))
                phoneNumber = ""
            }
            closeAction()
        }
    }
}

private extension PhoneNumberPopupViewModel {
    func setupBindings() {
        $phoneNumber
            .map { $0.range(of: "^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$", options: .regularExpression) != nil }
            .assign(to: &$isValid)
    }
}
