//
//  CallDirectoryHandler.swift
//  MunchCallDirectory
//
//  Created by Code Forge on 09.10.2023..
//

import Foundation
import CallKit

public final class CallDirectoryHandler: CXCallDirectoryProvider {
    private let phoneNumberManager = PhoneNumberManager()

    public override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        if context.isIncremental {
            addOrRemoveIncrementalBlockingPhoneNumbers(to: context)
            addOrRemoveIncrementalIdentificationPhoneNumbers(to: context)
        } else {
            addAllBlockingPhoneNumbers(to: context)
            addAllIdentificationPhoneNumbers(to: context)
        }

        context.completeRequest()
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        let allPhoneNumbers = phoneNumberManager.blockedNumbers.map { $0.id }
        addPhoneNumbers(allPhoneNumbers, to: context)
    }

    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Here, fetch the numbers you've added or removed since the last fetch.
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = []
        addPhoneNumbers(phoneNumbersToAdd, to: context)

        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = []
        removePhoneNumbers(phoneNumbersToRemove, from: context)
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        let allPhoneNumbersAndLabels = phoneNumberManager.suspiciousNumbers.map { ($0.id, $0.type.rawValue) }
        addIdentificationEntries(allPhoneNumbersAndLabels, to: context)
    }

    private func addOrRemoveIncrementalIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Again, fetch the numbers and labels you've added or removed since the last fetch.
        let phoneNumbersAndLabelsToAdd: [(CXCallDirectoryPhoneNumber, String)] = []
        addIdentificationEntries(phoneNumbersAndLabelsToAdd, to: context)

        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = []
        removeIdentificationEntries(phoneNumbersToRemove, from: context)
    }

    private func addPhoneNumbers(_ phoneNumbers: [CXCallDirectoryPhoneNumber], to context: CXCallDirectoryExtensionContext) {
        for phoneNumber in phoneNumbers.sorted() {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }

    private func removePhoneNumbers(_ phoneNumbers: [CXCallDirectoryPhoneNumber], from context: CXCallDirectoryExtensionContext) {
        for phoneNumber in phoneNumbers.sorted() {
            context.removeBlockingEntry(withPhoneNumber: phoneNumber)
        }
    }

    private func addIdentificationEntries(_ phoneNumbersAndLabels: [(CXCallDirectoryPhoneNumber, String)], to context: CXCallDirectoryExtensionContext) {
        let sortedEntries = phoneNumbersAndLabels.sorted(by: { $0.0 < $1.0 })
        for (phoneNumber, label) in sortedEntries {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }
    }

    private func removeIdentificationEntries(_ phoneNumbers: [CXCallDirectoryPhoneNumber], from context: CXCallDirectoryExtensionContext) {
        for phoneNumber in phoneNumbers.sorted() {
            context.removeIdentificationEntry(withPhoneNumber: phoneNumber)
        }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    public func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // Log or handle the error as needed.
        print("Call Directory Extension request failed: \(error.localizedDescription)")
    }
}
