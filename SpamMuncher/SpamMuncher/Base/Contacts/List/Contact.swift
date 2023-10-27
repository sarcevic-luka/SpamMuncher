//
//  Contact.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import UIKit
import Contacts

struct Contact: Identifiable {
    let id: UUID = UUID()
    var name: String
    var phoneNumber: String
    var image: UIImage?
    
    init(from cnContact: CNContact) {
        let givenName = cnContact.givenName
        let familyName = cnContact.familyName
        let organizationName = cnContact.organizationName
        
        if !givenName.isEmpty && !familyName.isEmpty {
            self.name = "\(givenName) \(familyName)"
        } else if !givenName.isEmpty {
            self.name = givenName
        } else if !familyName.isEmpty {
            self.name = familyName
        } else if !organizationName.isEmpty {
            self.name = organizationName
        } else {
            self.name = ""
        }

        self.phoneNumber = cnContact.phoneNumbers.first?.value.stringValue ?? ""
        
        if let imageData = cnContact.imageData {
            self.image = UIImage(data: imageData)
        } else {
            self.image = nil
        }
    }
}
