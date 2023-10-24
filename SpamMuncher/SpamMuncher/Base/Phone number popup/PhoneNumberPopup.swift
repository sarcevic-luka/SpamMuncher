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
    @ObservedObject var viewModel: PhoneNumberPopupViewModel
    let onAdd: () -> Void
    
    var body: some View {
        BackgroundOverlayView(isPresented: $isPresented) {
            mainContent
                .padding(20)
        }
    }
}

// MARK: - Private Views

private extension PhoneNumberPopup {
    var mainContent: some View {
        VStack(spacing: 20) {
            header
            numberInputField
            segmentedControl
            if let valid = viewModel.isValid, !valid {
                validationWarning
            }
            actionButtons
        }
        .padding(20)
        .background(Color.lowLightColor)
        .cornerRadius(15)
        .offset(y: -50)
    }
    
    var header: some View {
        Text("Enter Phone Number")
            .font(.headline)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
    
    var numberInputField: some View {
        HStack {
            Image(systemName: "phone.fill").foregroundColor(.gray)
            TextField("Phone Number", text: $viewModel.phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }
    
    var numberTypeSegment: some View {
        Picker("Number Type", selection: $viewModel.selectedNumberType) {
            ForEach(PhoneNumberType.allCases, id: \.self) { type in
                Text(type.rawValue.capitalized).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var segmentedControl: some View {
        AdaptiveTextSegmentedScrollControl(selectedValue: $viewModel.selectedNumberType)
            .padding(.horizontal, 0)
            .zIndex(1)
    }

    var validationWarning: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
            Text("Invalid phone number").foregroundColor(.alertColor)
        }
    }
    
    var actionButtons: some View {
        HStack(spacing: 15) {
            addButton
            cancelButton
        }
    }
    
    var addButton: some View {
        Button(action: {
            viewModel.validateAndAddPhoneNumber(onAdd: onAdd)
        }) {
            Text("Add")
                .padding(.horizontal, 30)
        }
        .disabled(viewModel.isAddButtonDisabled)
    }

    var cancelButton: some View {
        Button(action: {
            withAnimation {
                isPresented = false
            }
        }) {
            Text("Cancel")
                .padding(.horizontal, 12)
        }
        .customStyle(.secondary)
    }
}

// MARK: - Previews

struct PhoneNumberPopup_Previews: PreviewProvider {
    @State static var isPresented = true
    static let viewModel1 = {
        let vm = PhoneNumberPopupViewModel()
        vm.phoneNumber = ""
        return vm
    }()
    
    static let viewModel2 = {
        let vm = PhoneNumberPopupViewModel()
        vm.phoneNumber = "123456"
        vm.isValid = false
        return vm
    }()
    
    static var previews: some View {
        Group {
            PhoneNumberPopup(
                isPresented: $isPresented,
                viewModel: viewModel1,
                onAdd: {
                    if viewModel1.phoneNumber.count == 10 {
                        viewModel1.isValid = true
                    } else {
                        viewModel1.isValid = false
                    }
                }
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Default state")
            
            PhoneNumberPopup(
                isPresented: $isPresented,
                viewModel: viewModel2,
                onAdd: {}
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Invalid phone number")
        }
    }
}
