//
//  ContactRowView.swift
//  SpamMuncher
//
//  Created by Code Forge on 26.10.2023..
//

import SwiftUI
import MunchUI
import MunchModel

struct ContactRowView: View {
    let contact: PhoneNumber
    let onDelete: () -> Void

    var body: some View {
        HStack {
            contactInfo
            Spacer()
            contactType
            deleteButton
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
        .listRowBackground(Color.clear)
    }
    
    private var contactInfo: some View {
        VStack(alignment: .leading) {
            contact.name.flatMap {
                $0.isEmpty ? nil : Text($0)
            }
            Text("\(contact.id)".formattedAsPhoneNumber)
                .font(.subheadline)
                .foregroundColor(.offWhite)
        }
    }
    
    private var contactType: some View {
        Text(contact.type.rawValue)
    }

    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "trash.fill")
                .foregroundColor(.amberYellow)
                .padding(.leading)
        }
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
