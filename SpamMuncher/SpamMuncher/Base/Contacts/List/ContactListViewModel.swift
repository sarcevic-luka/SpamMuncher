//
//  ContactsListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import Contacts
import UIKit
import MunchUI

class ContactListViewModel: ObservableObject {
    @Published var contactsDictionary: [Character: [Contact]] = [:]
    @Published var fetchError: Error?
    @Published var searchText: String = ""
    @Published var isAppleSupportPopupVisible: Bool = false
    @Published var infoViewState: InfoView.InfoViewState = .hidden

    var phoneNumberManager: PhoneNumberManaging
    private let contactFetchingQueue = DispatchQueue(label: "com.SmapMuncher.contactFetching", qos: .userInitiated)

    init(phoneNumberManager: PhoneNumberManaging) {
        self.phoneNumberManager = phoneNumberManager
        requestContactPermissions()
    }

    /// Requests permission to access contacts and fetches them if permission is granted.
    func requestContactPermissions() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            // Check permissions before deciding which thread to use.
            if granted {
                self?.fetchContacts()
            } else {
                DispatchQueue.main.async {
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
            let lowercasedSearchText = searchText.lowercased()
            for (key, contacts) in contactsDictionary {
                let filtered = contacts.filter { $0.name.lowercased().contains(lowercasedSearchText) }
                if !filtered.isEmpty {
                    filteredContacts[key] = filtered
                }
            }
            return filteredContacts
        }
    }
}

// MARK: - Private methods

private extension ContactListViewModel {
    /// Fetches contacts from the contact store and filters out contacts without a name or number.
    func fetchContacts() {
        let contactStore = CNContactStore()
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor
        ]
        let request = CNContactFetchRequest(keysToFetch: keys)

        contactFetchingQueue.async { [weak self] in
            do {
                var newContacts: [Character: [Contact]] = [:]

                try contactStore.enumerateContacts(with: request) { (contact, stop) in
                    guard (!contact.givenName.isEmpty ||
                           !contact.familyName.isEmpty ||
                           !contact.organizationName.isEmpty),
                          !contact.phoneNumbers.isEmpty else {
                        return
                    }

                    let contactModel = Contact(from: contact)
                    let firstLetter = contactModel.name.first ?? "#"
                    if newContacts[firstLetter] != nil {
                        newContacts[firstLetter]?.append(contactModel)
                    } else {
                        newContacts[firstLetter] = [contactModel]
                    }
                }

                DispatchQueue.main.async {
                    self?.contactsDictionary = newContacts
                }
            } catch {
                DispatchQueue.main.async {
                    self?.infoViewState = .error(message: "Something went wrong while fetching contacts: \(error.localizedDescription)")
                }
            }
        }
    }
}
