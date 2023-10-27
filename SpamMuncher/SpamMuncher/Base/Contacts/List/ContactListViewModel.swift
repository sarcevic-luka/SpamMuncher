//
//  ContactsListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import Contacts
import UIKit
import MunchUI
import MunchCallDirectory

class ContactsListViewModel: ObservableObject {
    @Published var contactsDictionary: [Character: [Contact]] = [:]
    @Published var fetchError: Error?
    @Published var searchText: String = ""
    @Published var isAppleSupportPopupVisible: Bool = false
    @Published var infoViewState: InfoView.InfoViewState = .hidden

    var phoneNumberManager: PhoneNumberManaging

    init(phoneNumberManager: PhoneNumberManaging) {
        self.phoneNumberManager = phoneNumberManager
        requestContactPermissions()
    }

    func requestContactPermissions() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async { [weak self] in
                if granted {
                    self?.fetchContacts()
                } else {
                    self?.infoViewState = .noContactsPermissionGranted
                }
            }
        }
    }

    func contacts() -> [Character: [Contact]] {
        if searchText.isEmpty {
            return contactsDictionary
        } else {
            var filteredContacts: [Character: [Contact]] = [:]
            for (key, contacts) in contactsDictionary {
                let filtered = contacts.filter { $0.name.contains(searchText) }
                if !filtered.isEmpty {
                    filteredContacts[key] = filtered
                }
            }
            return filteredContacts
        }
    }
}

// MARK: - Private methods

private extension ContactsListViewModel {
    private func fetchContacts() {
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                var newContacts: [Character: [Contact]] = [:]

                try contactStore.enumerateContacts(with: request) { (contact, stop) in
                    if (!contact.givenName.isEmpty || !contact.familyName.isEmpty || !contact.organizationName.isEmpty) && !contact.phoneNumbers.isEmpty {
                        let contactModel = Contact(from: contact)
                        let firstLetter = contactModel.name.first ?? "#"
                        if newContacts[firstLetter] != nil {
                            newContacts[firstLetter]?.append(contactModel)
                        } else {
                            newContacts[firstLetter] = [contactModel]
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.contactsDictionary = newContacts
                }
            } catch {
                DispatchQueue.main.async {
                    self.infoViewState = .error(message: "Something went wrong while fetching contacts: \(error.localizedDescription)")
                }
            }
        }
    }

}
