//
//  BlockListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 08.10.2023..
//

import Foundation
import SwiftUI
import MunchUI
import MunchModel
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
    @Published var contacts: [PhoneNumber] = []
    @Published var searchText: String = ""
    @Published var phoneNumberManager: PhoneNumberManaging
    @Published var infoViewState: InfoView.InfoViewState = .hidden

    private var bag = Set<AnyCancellable>()

    init(phoneNumberManager: PhoneNumberManaging = PhoneNumberManager()) {
        self.phoneNumberManager = phoneNumberManager
        setObservers()
    }

    func deleteContact(contact: PhoneNumber) {
        phoneNumberManager.removeNumber(contact)
    }

    func togglePhoneNumberPopup() {
        isPhoneNumberPopupVisible.toggle()
    }
}

private extension BlockListViewModel {
    func setObservers() {
        Publishers.CombineLatest4(
            $selectedFilterType,
            $searchText,
            phoneNumberManager.blockedNumbers,
            phoneNumberManager.suspiciousNumbers
        )
        .map { [weak self] (filter, searchText, blockedNumbers, suspiciousNumbers) in
            self?.filteredContacts(
                with: filter,
                for: searchText,
                numbersList: (blockedNumbers: blockedNumbers, suspiciousNumbers: suspiciousNumbers)
            ) ?? []
        }
        .sink { [weak self] in
            self?.contacts = $0
            self?.updateInfoViewState(
                filter: self?.selectedFilterType ?? .all,
                searchText: self?.searchText ?? "",
                contacts: $0)
        }
        .store(in: &bag)
    }

    func updateInfoViewState(filter: FilterType, searchText: String, contacts: [PhoneNumber]) {
        if contacts.isEmpty {
            if searchText.isEmpty {
                infoViewState = .noNumbersAdded(filterText: filter.rawValue)
            } else {
                infoViewState = .noNumbersFound(searchText: .constant(searchText))
            }
        } else {
            infoViewState = .hidden
        }
    }

    func filteredContacts(with filter: FilterType, for searchText: String, numbersList:  (blockedNumbers: [PhoneNumber],suspiciousNumbers: [PhoneNumber])) -> [PhoneNumber] {
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
}
