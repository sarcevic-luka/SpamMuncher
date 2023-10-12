//
//  NumberEntryView.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import SwiftUI
import MunchUI

struct NumberEntryView: View {
    @Binding var isPresented: Bool
    @State private var mobileNumber: String = ""
    @State private var callType: String = "Normal"
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter mobile number", text: $mobileNumber)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            
            Text(isValidNumber(mobileNumber) ? "Valid Number" : "Invalid Number")
                .foregroundColor(isValidNumber(mobileNumber) ? .green : .red)
            
            Picker("Call Type", selection: $callType) {
                Text("Normal").tag("Normal")
                Text("Suspicious").tag("Suspicious")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                Spacer()
                Button("Enter") {
                    // Handle the entered data
                    isPresented = false
                }
            }
        }
        .padding()
        .background(
            Color.purple
        )
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
    }
    
    func isValidNumber(_ number: String) -> Bool {
        // Add logic to validate mobile number. For simplicity, let's just check if it's not empty.
        return !number.isEmpty
    }
}

struct NumberEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NumberEntryView(isPresented: .constant(true))
    }
}
