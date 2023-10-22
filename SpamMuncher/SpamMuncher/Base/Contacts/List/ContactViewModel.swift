//
//  ContactViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import Contacts
import UIKit

class ContactsViewModel: ObservableObject {
    @Published var contactsDictionary: [Character: [Contact]] = [:]
    @Published var fetchError: Error?
    @Published var searchText: String = ""
    @Published var isAppleSupportPopupVisible: Bool = false

    func fetchContacts() {
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                var newContacts: [Character: [Contact]] = [:]
                
                try contactStore.enumerateContacts(with: request) { (contact, stop) in
                    let contactModel = Contact(from: contact)
                    let firstLetter = contactModel.name.first ?? "#"
                    if newContacts[firstLetter] != nil {
                        newContacts[firstLetter]?.append(contactModel)
                    } else {
                        newContacts[firstLetter] = [contactModel]
                    }
                }
                
                DispatchQueue.main.async {
                    self.contactsDictionary = newContacts
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.fetchError = error
                }
                print("Failed to fetch contacts:", error)
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
