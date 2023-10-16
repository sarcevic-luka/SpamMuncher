//
//  PhoneNumberPopup.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import SwiftUI
import MunchUI

struct PhoneNumberPopup: View {
    @Binding var isPresented: Bool
    @Binding var phoneNumber: String
    @Binding var isValid: Bool?
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Phone Number")
                .font(.headline)
                .foregroundColor(.baseColor)
            HStack {
                Image(systemName: "phone.fill") // Phone icon for the text field
                    .foregroundColor(.gray)
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.leading)
            }

            if let valid = isValid, !valid {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill") // Warning icon
                        .foregroundColor(.red)
                    Text("Invalid phone number")
                        .foregroundColor(.red)
                }
            }

            HStack(spacing: 15) {
                Button("Add") {
                    onAdd()
                }
                .disabled(phoneNumber.isEmpty)
                .padding()
                .background(Color.blue) // Your app's primary color
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Cancel") {
                    withAnimation {
                        isPresented = false
                    }
                }
                .padding()
                .border(Color.blue, width: 2) // Your app's primary color
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .overlay(
            Button(action: {
                withAnimation {
                    isPresented = false
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.top, 5)
            .padding(.trailing, 5)
            , alignment: .topTrailing // Close button on top right
        )
    }
}


struct PhoneNumberPopup_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var phoneNumber = ""
    @State static var isValid: Bool? = nil
    
    static var previews: some View {
        Group {
            PhoneNumberPopup(
                isPresented: $isPresented,
                phoneNumber: $phoneNumber,
                isValid: $isValid,
                onAdd: {
                    if phoneNumber.count == 10 {
                        isValid = true
                    } else {
                        isValid = false
                    }
                }
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Default state")
            
            PhoneNumberPopup(
                isPresented: $isPresented,
                phoneNumber: .constant("123456"),
                isValid: .constant(false),
                onAdd: {}
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Invalid phone number")
        }
    }
}
