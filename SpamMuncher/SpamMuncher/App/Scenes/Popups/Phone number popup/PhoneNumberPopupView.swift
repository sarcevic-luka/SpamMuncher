//
//  PhoneNumberPopup.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import SwiftUI
import MunchUI
import MunchModel
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
            validationMessage
            actionButtons
        }
        .padding(20)
        .background(Color.deepBlack)
        .cornerRadius(15)
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
            PhoneNumberField("+XXX XX XXX XXXX", text: $viewModel.phoneNumber)
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

    var validationMessage: some View {
        HStack {
            Image(systemName: viewModel.validationState.validationImageName)
            Text(viewModel.validationState.localizedDescription)
        }
        .foregroundColor(viewModel.validationState.validationColor)
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
        .customStyle(.primary)
        .disabled(viewModel.validationState == .invalid)
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
    var blockedNumbers: CurrentValueSubject<[PhoneNumber], Never>
    var suspiciousNumbers: CurrentValueSubject<[PhoneNumber], Never>

    init() {
        blockedNumbers = CurrentValueSubject<[PhoneNumber], Never>([])
        suspiciousNumbers = CurrentValueSubject<[PhoneNumber], Never>([])
    }

    func addNumber(_ number: PhoneNumber) {
        switch number.type {
        case .blocked:
            var currentNumbers = blockedNumbers.value
            currentNumbers.append(number)
            blockedNumbers.send(currentNumbers)
        case .suspicious:
            var currentNumbers = suspiciousNumbers.value
            currentNumbers.append(number)
            suspiciousNumbers.send(currentNumbers)
        }
    }

    func removeNumber(_ number: PhoneNumber) {
        switch number.type {
        case .blocked:
            var currentNumbers = blockedNumbers.value
            currentNumbers.removeAll { $0.id == number.id }
            blockedNumbers.send(currentNumbers)
        case .suspicious:
            var currentNumbers = suspiciousNumbers.value
            currentNumbers.removeAll { $0.id == number.id }
            suspiciousNumbers.send(currentNumbers)
        }
    }
}
