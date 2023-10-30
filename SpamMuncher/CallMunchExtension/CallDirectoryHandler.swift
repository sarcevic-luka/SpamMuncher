//
//  CallDirectoryHandler.swift
//  CallMunchExtension
//
//  Created by Code Forge on 30.10.2023..
//

import Foundation
import CallKit
import MunchModel

class CallDirectoryHandler: CXCallDirectoryProvider {
    enum PhoneNumberType: String, Codable, CaseIterable {
        case blocked = "Blocked"
        case suspicious = "Suspicious"
    }

    private let defaults = UserDefaults(suiteName: "group.luka.sarcevic.SpamMuncherApp")!
    
    private func fetchNumbers(ofType type: PhoneNumberType) -> [CXCallDirectoryPhoneNumber] {
        guard let data = defaults.data(forKey: type.rawValue + "PhoneNumbers"),
              let numbers = try? JSONDecoder().decode([PhoneNumber].self, from: data) else {
            return []
        }
        return numbers.map { $0.id }  
    }

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        
        
        addAllBlockingPhoneNumbers(to: context)
        addAllIdentificationPhoneNumbers(to: context)


        context.completeRequest()
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        let blockedNumbers = fetchNumbers(ofType: .blocked)
        for phoneNumber in blockedNumbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        let suspiciousNumbers = fetchNumbers(ofType: .suspicious)
        let labels = Array(repeating: "Suspicious", count: suspiciousNumbers.count) // Use appropriate labels for your suspicious numbers
        for (phoneNumber, label) in zip(suspiciousNumbers, labels) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }
    }

    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = [ 1_408_555_1234 ]
        for phoneNumber in phoneNumbersToAdd {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }

        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = [ 1_800_555_5555 ]
        for phoneNumber in phoneNumbersToRemove {
            context.removeBlockingEntry(withPhoneNumber: phoneNumber)
        }

        // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
    }

    private func addOrRemoveIncrementalIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to identify (and their identification labels) from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = [ 1_408_555_5678 ]
        let labelsToAdd = [ "New local business" ]

        for (phoneNumber, label) in zip(phoneNumbersToAdd, labelsToAdd) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }

        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = [ 1_888_555_5555 ]

        for phoneNumber in phoneNumbersToRemove {
            context.removeIdentificationEntry(withPhoneNumber: phoneNumber)
        }

        // Record the most-recently loaded set of identification entries in data store for the next incremental load...
    }

}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}
