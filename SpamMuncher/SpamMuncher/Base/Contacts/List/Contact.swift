//
//  Contact.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import UIKit
import Contacts

struct Contact {
    var name: String
    var phoneNumber: String
    var image: UIImage?
    
    init(from cnContact: CNContact) {
        self.name = cnContact.givenName
        self.phoneNumber = cnContact.phoneNumbers.first?.value.stringValue ?? ""
        if let imageData = cnContact.imageData {
            self.image = UIImage(data: imageData)
        } else {
            self.image = nil
        }
    }
}
