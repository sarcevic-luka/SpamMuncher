//
//  PhoneNumberField.swift
//  SpamMuncher
//
//  Created by Code Forge on 26.10.2023..
//

import SwiftUI

struct PhoneNumberField: View {
    @Binding var text: String
    @State private var lastValidText: String = ""
    
    let placeholder: String
    private let maxNumberOfNumbersInPhoneNumber = 13 // This is just for testing - real app would have different approach
    
    init(
        _ placeholder: String,
        text: Binding<String>
    ) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .onChange(of: text) { newValue in
                let filtered = newValue.filter { $0.isWholeNumber }
                if filtered.count <= maxNumberOfNumbersInPhoneNumber {
                    lastValidText = filtered.formattedAsPhoneNumberWithRegion
                    text = lastValidText
                } else {
                    text = lastValidText
                }
            }
    }
}
