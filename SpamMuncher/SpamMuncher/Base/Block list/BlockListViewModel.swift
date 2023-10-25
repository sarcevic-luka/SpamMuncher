//
//  BlockListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import Foundation
import SwiftUI
import MunchUI
import MunchCallDirectory
import CallKit
import Combine

final class BlockListViewModel: ObservableObject {
    enum FilterType: String, CaseIterable {
        case all = "All"
        case blocked = "Blocked"
        case suspicious = "Suspicious"

        var phoneNumberType: PhoneNumberType? {
            switch self {
            case .all:
                return nil
            case .blocked:
                return .blocked
            case .suspicious:
                return .suspicious
            }
        }
    }

    @Published var selectedFilterType: FilterType = .all
    @Published var isPhoneNumberPopupVisible: Bool = false
    @Published var enteredPhoneNumber: String = ""
    @Published var isPhoneNumberValid: Bool? = nil
    @Published var contacts: [PhoneNumber] = []
    @Published var phoneNumberPopupViewModel = PhoneNumberPopupViewModel()
    @Published var searchText: String = ""
    @Published var phoneNumberManager: PhoneNumberManaging
    @Published var infoViewState: InfoView.InfoViewState = .hidden
    
    private var bag = Set<AnyCancellable>()

    init(phoneNumberManager: PhoneNumberManaging = PhoneNumberManager()) {
        self.phoneNumberManager = phoneNumberManager
        setObservers()
    }
    
    private func setObservers() {
        $contacts
            .combineLatest($searchText)
            .sink { [weak self] contacts, searchText in
                if contacts.isEmpty {
                    if searchText.isEmpty {
                        self?.infoViewState = .noNumbersAdded(filterText: self?.selectedFilterType.rawValue ?? "All")
                    } else {
                        self?.infoViewState = .noNumbersFound(searchText: .constant(searchText))
                    }
                } else {
                    self?.infoViewState = .hidden
                }
            }
            .store(in: &bag)

        let changedPublisher = Publishers.CombineLatest(
            phoneNumberManager.blockedNumbersPublisher,
            phoneNumberManager.suspiciousNumbersPublisher
        )
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest3(
            $selectedFilterType,
            $searchText,
            changedPublisher
        )
            .map {  [weak self] filter, searchText, lists in
                self?.filteredContacts(with: filter, for: searchText, numbersList: lists) ?? []
            }
            .sink { [weak self] in
                self?.contacts = $0
            }
            .store(in: &bag)
    }
    
    private func filteredContacts(with filter: FilterType, for searchText: String, numbersList:  (blockedNumbers: [PhoneNumber],suspiciousNumbers: [PhoneNumber])) -> [PhoneNumber] {
        let allContacts: [PhoneNumber]

        switch filter {
        case .blocked:
            allContacts = numbersList.blockedNumbers
        case .suspicious:
            allContacts = numbersList.suspiciousNumbers
        case .all:
            allContacts = numbersList.blockedNumbers + numbersList.suspiciousNumbers
        }
        
        if !searchText.isEmpty {
            return allContacts.filter { contact in
                contact.id.description.contains(searchText) || (contact.name?.contains(searchText) ?? false)
            }
        } else {
            return allContacts
        }
    }

    func addPhoneNumber() {
        if isPhoneNumberValid == true, let validNumber = Int64(enteredPhoneNumber) {

            let newPhoneNumber = PhoneNumber(id: validNumber, type: phoneNumberPopupViewModel.selectedNumberType)
            phoneNumberManager.addNumber(newPhoneNumber)
            
            withAnimation {
                isPhoneNumberPopupVisible = false
            }
            enteredPhoneNumber = ""
            isPhoneNumberValid = nil
        }
    }

    func deleteContact(contact: PhoneNumber) {
        phoneNumberManager.removeNumber(contact)
    }
    
    private func checkPhoneNumberValidity() {
        isPhoneNumberValid = enteredPhoneNumber.range(of: "^[0-9]{10}$", options: .regularExpression) != nil
    }

    private func refreshCallDirectory() {
        let directoryHandler = CallDirectoryHandler()
        let context = CXCallDirectoryExtensionContext()
        directoryHandler.beginRequest(with: context)
    }

    func togglePhoneNumberPopup() {
        withAnimation {
            isPhoneNumberPopupVisible.toggle()
            phoneNumberPopupViewModel.phoneNumber = self.enteredPhoneNumber
        }
    }
    
    func handleAddPhoneNumber() {
        enteredPhoneNumber = phoneNumberPopupViewModel.phoneNumber
        checkPhoneNumberValidity()
        if isPhoneNumberValid == true {
            addPhoneNumber()
        }
        
    }
}
