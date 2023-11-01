//
//  BlockListViewModelTests.swift
//  SpamMuncherTests
//
//  Created by Code Forge on 01.11.2023..
//

import XCTest
import Combine
import MunchModel
@testable import SpamMuncher

class BlockListViewModelTests: XCTestCase {
    var viewModel: BlockListViewModel!
    var mockPhoneNumberManager: MockPhoneNumberManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockPhoneNumberManager = MockPhoneNumberManager()
        viewModel = BlockListViewModel(phoneNumberManager: mockPhoneNumberManager)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockPhoneNumberManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialFilterTypeIsAll() {
        XCTAssertEqual(viewModel.selectedFilterType, .all, "Initial filter type should be .all")
    }

    func testTogglePhoneNumberPopup() {
        XCTAssertFalse(viewModel.isPhoneNumberPopupVisible, "Popup should initially be invisible")
        viewModel.togglePhoneNumberPopup()
        XCTAssertTrue(viewModel.isPhoneNumberPopupVisible, "Popup should be visible after toggle")
    }

    func testFilterType_all_returnsAllContacts() {
        viewModel.selectedFilterType = .all
        let expectedContacts = mockPhoneNumberManager.blockedNumbers.value + mockPhoneNumberManager.suspiciousNumbers.value
        XCTAssertEqual(viewModel.contacts, expectedContacts, "Contacts should match all blocked and suspicious numbers")
    }

    func testDeleteContactRemovesContact() {
        let contact = PhoneNumber(id: 1234567890, type: .blocked)
        XCTAssertTrue(mockPhoneNumberManager.blockedNumbers.value.contains(contact), "Contact should initially be in blocked numbers")
        viewModel.deleteContact(contact: contact)
        XCTAssertFalse(mockPhoneNumberManager.blockedNumbers.value.contains(contact), "Contact should be removed from blocked numbers")
    }

    func testTogglePhoneNumberPopupTogglesVisibility() {
        let initialVisibility = viewModel.isPhoneNumberPopupVisible
        viewModel.togglePhoneNumberPopup()
        XCTAssertNotEqual(viewModel.isPhoneNumberPopupVisible, initialVisibility, "Phone number popup visibility should be toggled")
    }

    func testFilterContacts() {
        viewModel.selectedFilterType = .blocked
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.contacts.count, mockPhoneNumberManager.blockedNumbers.value.count, "Contacts should be filtered by blocked type")

        viewModel.selectedFilterType = .suspicious
        XCTAssertEqual(viewModel.contacts.count, mockPhoneNumberManager.suspiciousNumbers.value.count, "Contacts should be filtered by suspicious type")

        viewModel.selectedFilterType = .all
        XCTAssertEqual(viewModel.contacts.count, mockPhoneNumberManager.blockedNumbers.value.count + mockPhoneNumberManager.suspiciousNumbers.value.count, "Contacts should show all when filter is set to all")
    }
    
    func testSearchFiltering() {
        viewModel.selectedFilterType = .all
        viewModel.searchText = "Alice"
        let filteredContacts = viewModel.contacts.filter { $0.name == "Alice" }
        XCTAssertEqual(filteredContacts.count, viewModel.contacts.count, "Contacts should be filtered by search text")
    }
}

