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
    var name: String
    var phoneNumber: String
    var image: UIImage?
    
    init(from cnContact: CNContact) {
        let namesAndOrganization = [cnContact.givenName, cnContact.familyName, cnContact.organizationName].filter { !$0.isEmpty }
        
        self.name = namesAndOrganization.joined(separator: " ")

        self.phoneNumber = cnContact.phoneNumbers.first?.value.stringValue ?? ""
        
        self.image = cnContact.imageData.flatMap(UIImage.init)
    }
}
