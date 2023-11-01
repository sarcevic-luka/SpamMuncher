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
    private let defaults = UserDefaults(suiteName: "group.luka.sarcevic.SpamMuncherApp")
        
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
        let labels = Array(repeating: "Suspicious", count: suspiciousNumbers.count) 
        for (phoneNumber, label) in zip(suspiciousNumbers, labels) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }
    }
    
    private func fetchNumbers(ofType type: PhoneNumberType) -> [CXCallDirectoryPhoneNumber] {
        guard let unwrappedDefaults = defaults,
              let data = unwrappedDefaults.data(forKey: type.rawValue + "PhoneNumbers"),
              let numbers = try? JSONDecoder().decode([PhoneNumber].self, from: data) else {
            return []
        }
        return numbers.map { $0.id }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) { }
}
