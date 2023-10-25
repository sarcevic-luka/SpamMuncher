//
//  ContactDetailViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 24.10.2023..
//

import Combine
import UIKit
import CallKit

class ContactDetailViewModel: ObservableObject {
    @Published var isContactBlocked: Bool = false

    let contact: Contact

    var contactPhoneNumberAsId: Int64 {
        return Int64(contact.phoneNumber) ?? 0
    }


    private var cancellables: Set<AnyCancellable> = []
     var phoneNumberManager: PhoneNumberManaging

    init(
        contact: Contact,
        phoneNumberManager: PhoneNumberManaging
    ) {
        self.contact = contact
        self.phoneNumberManager = phoneNumberManager
        self.isContactBlocked = isContactBlockedInitially()
        
        setupBindings()
    }

    func callContact() {
        if let url = URL(string: "tel://\(contact.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func messageContact() {
        if let url = URL(string: "sms:\(contact.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func blockOrUnblockContact() {
        let phoneNumber = PhoneNumber(id: contact.phoneNumber.toCXCallDirectoryPhoneNumber(), label: PhoneNumberType.blocked.rawValue, name: contact.name)
        
        if isContactBlocked {
            phoneNumberManager.removeNumber(phoneNumber, type: .blocked)
        } else {
            phoneNumberManager.addNumber(phoneNumber, type: .blocked)
        }
        
//        isContactBlocked = isBlocked
    }
    
    private func setupBindings() {
        phoneNumberManager.blockedNumbersPublisher
            .sink { [weak self] _ in
                self?.isContactBlocked = self?.isContactBlockedInitially() ?? false
            }
            .store(in: &cancellables)
    }
    
    private func isContactBlockedInitially() -> Bool {
        return phoneNumberManager.blockedNumbers.contains { $0.id == contactPhoneNumberAsId }
    }
}
