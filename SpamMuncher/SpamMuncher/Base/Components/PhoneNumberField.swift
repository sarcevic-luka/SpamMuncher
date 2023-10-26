//
//  PhoneNumberField.swift
//  SpamMuncher
//
//  Created by Code Forge on 26.10.2023..
//

import SwiftUI

struct PhoneNumberField: View {
    @Binding var text: String
    let placeholder: String
    @State private var lastValidText: String = ""
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .onChange(of: text) { newValue in
                let filtered = newValue.filter { $0.isWholeNumber }
                if filtered.count <= 10 {
                    lastValidText = filtered.formattedAsPhoneNumber
                    text = lastValidText
                } else {
                    text = lastValidText
                }
            }
    }
}
