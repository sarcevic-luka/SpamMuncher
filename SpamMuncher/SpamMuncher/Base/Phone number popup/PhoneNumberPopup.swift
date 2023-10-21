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
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    isPresented = false
                }
            }
            .overlay(
                contentBox
            )
    }
    
    var contentBox: some View {
        VStack(spacing: 20) {
            Text("Enter Phone Number")
                .font(.headline)
                .foregroundColor(.baseColor)
            
            numberInputField
            
            if let valid = viewModel.isValid, !valid {
                validationWarning
            }

            actionButtons
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .overlay(
            closeButton,
            alignment: .topTrailing
        )
    }
    
    var numberInputField: some View {
        HStack {
            Image(systemName: "phone.fill").foregroundColor(.gray)
            TextField("Phone Number", text: $viewModel.phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.leading)
        }
    }
    
    var validationWarning: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
            Text("Invalid phone number").foregroundColor(.red)
        }
    }
    
    var actionButtons: some View {
        HStack(spacing: 15) {
            Button("Add") {
                viewModel.validateAndAddPhoneNumber(onAdd: onAdd)
            }
            .disabled(viewModel.isAddButtonDisabled)
            .buttonStyle(PrimaryButtonStyle())
            
            Button("Cancel") {
                withAnimation {
                    isPresented = false
                }
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }
    
    var closeButton: some View {
        Button(action: {
            withAnimation {
                isPresented = false
            }
        }) {
            Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
        }
        .padding([.top, .trailing], 5)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .border(Color.blue, width: 2)
            .cornerRadius(8)
    }
}


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
