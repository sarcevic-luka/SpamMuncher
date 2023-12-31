//
//  PhoneNumberPopupViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 21.10.2023..
//

import Foundation
import Combine
import MunchModel
import MunchUI
import SwiftUI

class PhoneNumberPopupViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var validationState: ValidationState = .invalid
    @Published var selectedNumberType: PhoneNumberType = .suspicious

    enum ValidationState: Equatable {
        case valid
        case invalid
        
        var validationColor: Color {
            switch self {
            case .valid:
                return .offWhite
            case .invalid:
                return .crimsonRed
            }
        }
        
        var validationImageName: String {
            switch self {
            case .valid:
                return "checkmark.circle.fill"

            case .invalid:
                return "exclamationmark.triangle.fill"

            }
        }
        
        var localizedDescription: LocalizedStringKey {
            switch self {
            case .valid:
                return "ValidNumberFormat"
            case .invalid:
                return "EnterValidNumberFormat"
            }
        }
    }

    private var bag = Set<AnyCancellable>()
    private let maxNumberOfNumbersInPhoneNumber = 13 // This is just for testing - real app would have different approach
    private let phoneNumberManager: PhoneNumberManaging

    init(phoneNumberManager: PhoneNumberManaging) {
        self.phoneNumberManager = phoneNumberManager
        setupBindings()
    }

    func addPhoneNumberAndClose(_ closeAction: @escaping () -> Void) {
        let numericPhoneNumber = phoneNumber.filter { $0.isWholeNumber }
        if let validNumber = Int64(numericPhoneNumber) {
            phoneNumberManager.addNumber(PhoneNumber(id: validNumber, type: selectedNumberType))
            phoneNumber = ""
        }
        closeAction()
    }
}

// MARK: - Private methods

private extension PhoneNumberPopupViewModel {
    func setupBindings() {
        $phoneNumber
            .map { [weak self] phoneNumber in
                self?.validationStateForNumber(phoneNumber) ?? .invalid
            }
            .sink { [weak self] validationState in
                self?.validationState = validationState
            }
            .store(in: &bag) 
    }
    
    func validationStateForNumber(_ number: String) -> ValidationState {
        let filtered = number.filter { $0.isWholeNumber }
        if filtered.count <= maxNumberOfNumbersInPhoneNumber && number.range(of: "^\\+\\d{3} \\d{2} \\d{4} \\d{3}$", options: .regularExpression) != nil {
            return .valid
        } else {
            return .invalid
        }
    }
}
