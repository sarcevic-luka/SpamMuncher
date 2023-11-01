//
//  PhoneNumberManager.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import Foundation
import Combine
import CallKit
import MunchModel

public protocol PhoneNumberManaging {
    var blockedNumbers: CurrentValueSubject<[PhoneNumber], Never> { get }
    var suspiciousNumbers: CurrentValueSubject<[PhoneNumber], Never> { get }
    
    func addNumber(_ number: PhoneNumber)
    func removeNumber(_ number: PhoneNumber)
}


public final class PhoneNumberManager: ObservableObject, PhoneNumberManaging {
    
    private enum Action {
        case add, remove
    }
    
    public var blockedNumbers = CurrentValueSubject<[PhoneNumber], Never>([])
    public var suspiciousNumbers = CurrentValueSubject<[PhoneNumber], Never>([])
    private let firstLaunchKey = "isFirstLaunch"

    var defaults: UserDefaults?

    init(defaults: UserDefaults? = UserDefaults(suiteName: "group.luka.sarcevic.SpamMuncherApp")) {
        self.defaults = defaults
        
        if isFirstLaunch() {
            addDefaultNumbers()
            markFirstLaunchComplete()
        } else {
            self.blockedNumbers.value = (try? fetchNumbers(ofType: .blocked)) ?? []
            self.suspiciousNumbers.value = (try? fetchNumbers(ofType: .suspicious)) ?? []
        }
    }

    public func addNumber(_ number: PhoneNumber) {
        guard !numbers(for: number.type).contains(where: { $0.id == number.id }) else {
            return
        }
        updateNumbers(with: number, action: .add)
    }

    public func removeNumber(_ number: PhoneNumber) {
        updateNumbers(with: number, action: .remove)
    }
}

// MARK: - Helpers
private extension PhoneNumberManager {
    func key(for type: PhoneNumberType) -> String {
        return type.rawValue + "PhoneNumbers"
    }
    
    private func updateNumbers(with number: PhoneNumber, action: Action) {
        var numbers = numbers(for: number.type)
        
        switch action {
        case .add:
            numbers.append(number)
        case .remove:
            numbers.removeAll { $0.id == number.id }
        }
        
        do {
            try saveNumbers(numbers, ofType: number.type)
            setNumbers(numbers, for: number.type)
        } catch {
            print("Error updating numbers for \(number.type.rawValue): \(error)")
        }
        reloadExtensionData()
    }

    func numbers(for type: PhoneNumberType) -> [PhoneNumber] {
        (type == .blocked) ? blockedNumbers.value : suspiciousNumbers.value
    }

    func setNumbers(_ numbers: [PhoneNumber], for type: PhoneNumberType) {
        if type == .blocked {
            blockedNumbers.send(numbers)
        } else {
            suspiciousNumbers.send(numbers)
        }
    }

    func fetchNumbers(ofType type: PhoneNumberType) throws -> [PhoneNumber]? {
        guard let data = defaults?.data(forKey: key(for: type)) else { return nil }
        return try JSONDecoder().decode([PhoneNumber].self, from: data)
    }
    
    func saveNumbers(_ numbers: [PhoneNumber], ofType type: PhoneNumberType) throws {
        let data = try JSONEncoder().encode(numbers)
        defaults?.setValue(data, forKey: key(for: type))
    }
    
    func reloadExtensionData() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "luka.sarcevic.SpamMunchApp.CallMunchExtension") { error in
            if let error = error {
                print("Error reloading extension: \(error)")
            } else {
                print("Call Directory Extension reloaded successfully.")
            }
        }
    }
    
    // First launch helpers
    // wouldnt use those in real app like that
    func isFirstLaunch() -> Bool {
        return defaults?.bool(forKey: firstLaunchKey) == false
    }

    func markFirstLaunchComplete() {
        defaults?.set(true, forKey: firstLaunchKey)
    }
    
    func addDefaultNumbers() {
        let defaultBlockedNumber = PhoneNumber(id: 2539501212, type: .blocked)
        let defaultSuspiciousNumber = PhoneNumber(id: 4259501212, type: .suspicious)
        addNumber(defaultBlockedNumber)
        addNumber(defaultSuspiciousNumber)
    }
}
