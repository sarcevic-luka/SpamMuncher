//
//  ContactDetailViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 24.10.2023..
//

import Combine
import UIKit
import CallKit
import MunchModel

class ContactDetailViewModel: ObservableObject {
    @Published var isContactBlocked: Bool = false

    let contact: Contact
    let phoneNumberManager: PhoneNumberManaging
    
    var contactPhoneNumberAsId: Int64 {
        Int64(contact.phoneNumber) ?? 0
    }

    private var cancellables: Set<AnyCancellable> = []

    init(
        contact: Contact,
        phoneNumberManager: PhoneNumberManaging
    ) {
        self.contact = contact
        self.phoneNumberManager = phoneNumberManager
        
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
        let phoneNumber = PhoneNumber(id: contact.phoneNumber.toCXCallDirectoryPhoneNumber(), type: .blocked, name: contact.name)
        
        if isContactBlocked {
            phoneNumberManager.removeNumber(phoneNumber)
        } else {
            phoneNumberManager.addNumber(phoneNumber)
        }
    }
    
    private func setupBindings() {
        phoneNumberManager.blockedNumbers
            .sink { [weak self] blockedNumbersList in
                self?.isContactBlocked = blockedNumbersList.contains { $0.id == self?.contactPhoneNumberAsId }
            }
            .store(in: &cancellables)
    }
}
