//
//  ContactDetailView.swift
//  SpamMuncher
//
//  Created by Code Forge on 22.10.2023..
//

import SwiftUI

struct ContactDetailView: View {
    var contact: Contact

    var body: some View {
        VStack {
            if let image = contact.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
            Text(contact.name)
            Text(contact.phoneNumber)
            HStack {
                Image(systemName: "phone.fill")
                Image(systemName: "message.fill")
                Image(systemName: "shield.fill")
            }
            .font(.largeTitle)
            Spacer()
        }
        .padding()
    }
}
