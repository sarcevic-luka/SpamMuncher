//
//  MockPhoneNumberManager.swift
//  SpamMuncherTests
//
//  Created by Code Forge on 01.11.2023..
//

import Combine
import MunchModel
@testable import SpamMuncher

class MockPhoneNumberManager: PhoneNumberManaging {
    var blockedNumbers = CurrentValueSubject<[PhoneNumber], Never>([PhoneNumber(id: 1234567890, type: .blocked)])
    var suspiciousNumbers = CurrentValueSubject<[PhoneNumber], Never>([PhoneNumber(id: 9876543210, type: .suspicious)])

    func addNumber(_ number: PhoneNumber) {
        if number.type == .blocked {
            blockedNumbers.value.append(number)
        } else {
            suspiciousNumbers.value.append(number)
        }
    }

    func removeNumber(_ number: PhoneNumber) {
        if number.type == .blocked {
            blockedNumbers.value.removeAll { $0.id == number.id }
        } else {
            suspiciousNumbers.value.removeAll { $0.id == number.id }
        }
    }
}
