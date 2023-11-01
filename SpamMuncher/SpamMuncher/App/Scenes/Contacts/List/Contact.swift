//
//  Contact.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import UIKit
import Contacts

/// In real live app I would probably fetched all numbers and then block entire user contact if any of the numbers is spam.
struct Contact: Identifiable {
    let id: UUID = UUID()
    let name: String
    let phoneNumber: String
    let image: UIImage?
    
    init(from contact: CNContact) {
        let namesAndOrganization = [contact.givenName, contact.familyName, contact.organizationName].filter { !$0.isEmpty }
        
        self.name = namesAndOrganization.joined(separator: " ")

        self.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
        
        self.image = contact.imageData.flatMap(UIImage.init)
    }
}
