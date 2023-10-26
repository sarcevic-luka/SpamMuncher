//
//  PhoneNumberPopup.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import SwiftUI
import MunchUI
import Combine

struct PhoneNumberPopupView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PhoneNumberPopupViewModel

    var body: some View {
        BackgroundOverlayView(isPresented: $isPresented) {
            mainContent
                .padding(20)
        }
    }
}

// MARK: - Private Views

private extension PhoneNumberPopupView {
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
        .background(Color.deepBlack)
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
            Text("Invalid phone number").foregroundColor(.crimsonRed)
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
            viewModel.addPhoneNumberAndClose {
                withAnimation {
                    isPresented = false
                }
            }
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

struct PhoneNumberPopupView_Previews: PreviewProvider {
    @State static var isPresented = true
    static let viewModel1 = PhoneNumberPopupViewModel(phoneNumberManager: MockPhoneNumberManager())
    
    static let viewModel2: PhoneNumberPopupViewModel = {
        let vm = PhoneNumberPopupViewModel(phoneNumberManager: MockPhoneNumberManager())
        vm.phoneNumber = "123456"
        vm.isValid = false
        return vm
    }()
    
    static var previews: some View {
        Group {
            PhoneNumberPopupView(
                isPresented: $isPresented,
                viewModel: viewModel1
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Default state")
            
            PhoneNumberPopupView(
                isPresented: $isPresented,
                viewModel: viewModel2
            )
            .padding()
            .background(Color.gray.opacity(0.3))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Invalid phone number")
        }
    }
}

// MockPhoneNumberManager for preview purposes
class MockPhoneNumberManager: PhoneNumberManaging {
    var blockedNumbers: [PhoneNumber] = []
    var suspiciousNumbers: [PhoneNumber] = []

    var blockedNumbersPublisher: AnyPublisher<[PhoneNumber], Never> {
        Just(blockedNumbers).eraseToAnyPublisher()
    }

    var suspiciousNumbersPublisher: AnyPublisher<[PhoneNumber], Never> {
        Just(suspiciousNumbers).eraseToAnyPublisher()
    }

    func addNumber(_ number: PhoneNumber) {
        // Add a simple logic to append the number
        switch number.type {
        case .blocked:
            blockedNumbers.append(number)
        case .suspicious:
            suspiciousNumbers.append(number)
        }
    }

    func removeNumber(_ number: PhoneNumber) {
        // Add a simple logic to remove the number
        switch number.type {
        case .blocked:
            blockedNumbers.removeAll { $0.id == number.id }
        case .suspicious:
            suspiciousNumbers.removeAll { $0.id == number.id }
        }
    }
}
