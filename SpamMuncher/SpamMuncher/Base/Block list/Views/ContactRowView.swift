//
//  ContactRowView.swift
//  SpamMuncher
//
//  Created by Code Forge on 26.10.2023..
//

import SwiftUI
import MunchUI

struct ContactRowView: View {
    let contact: PhoneNumber
    var onDelete: () -> Void

    var body: some View {
        HStack {
            contactInfo
            Spacer()
            contactType
            deleteButton
        }
        .listRowStyling
    }
    
    private var contactInfo: some View {
        VStack(alignment: .leading) {
            contact.name.flatMap {
                $0.isEmpty ? nil : Text($0)
            }
            Text("\(contact.id)".formattedAsPhoneNumber)
                .font(.subheadline)
                .foregroundColor(.lowestLightColor)
        }
    }
    
    private var contactType: some View {
        Text(contact.type.rawValue)
    }

    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "trash.fill")
                .foregroundColor(.warningColor)
                .padding(.leading)
        }
    }
}

private extension View {
    var listRowStyling: some View {
        self
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 4)
            .listRowBackground(Color.clear)
    }
}

struct ContactRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                ContactRowView(contact: PhoneNumber(id: 1234567890, type: .blocked, name: "John Doe")) {}
                    .previewDisplayName("With Name")

                ContactRowView(contact: PhoneNumber(id: 1234567890, type: .suspicious)) {}
                    .previewDisplayName("Without Name")
            }
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color(.systemBackground))
        }
    }
}