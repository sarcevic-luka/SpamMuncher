//
//  PhoneNumberManager.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import Foundation

public final class PhoneNumberManager: ObservableObject {
    public enum Action {
        case add, remove
    }

    @Published public private(set) var blockedNumbers: [PhoneNumber] = []
    @Published public private(set) var suspiciousNumbers: [PhoneNumber] = []

    public static let shared = PhoneNumberManager(defaults: UserDefaults(suiteName: "group.luka.sarcevic.SpamMuncher")!)

    private let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        blockedNumbers = (try? fetchNumbers(ofType: .blocked)) ?? []
        suspiciousNumbers = (try? fetchNumbers(ofType: .suspicious)) ?? []
    }
    
    public func addNumber(_ number: PhoneNumber, type: PhoneNumberType) {
        updateNumbers(with: number, type: type, action: .add)
    }
    
    public func removeNumber(_ number: PhoneNumber, type: PhoneNumberType) {
        updateNumbers(with: number, type: type, action: .remove)
    }
}

// MARK: - Helpers
private extension PhoneNumberManager {
    enum PhoneNumberError: Error {
        case decodingError(Error)
        case encodingError(Error)
    }

    func key(for type: PhoneNumberType) -> String {
        return type.rawValue + "PhoneNumbers"
    }
    
    private func updateNumbers(with number: PhoneNumber, type: PhoneNumberType, action: Action) {
        var numbers = numbers(for: type)
        
        switch action {
        case .add:
            numbers.append(number)
        case .remove:
            numbers.removeAll { $0.id == number.id }
        }
        
        do {
            try saveNumbers(numbers, ofType: type)
            setNumbers(numbers, for: type)
        } catch let error as PhoneNumberError {
            // Handle or log error
            print(error)
        } catch {
            print("Error saving numbers for \(type.rawValue): \(error)")
        }
    }

    func numbers(for type: PhoneNumberType) -> [PhoneNumber] {
        return (type == .blocked) ? blockedNumbers : suspiciousNumbers
    }

    func setNumbers(_ numbers: [PhoneNumber], for type: PhoneNumberType) {
        if type == .blocked {
            blockedNumbers = numbers
        } else {
            suspiciousNumbers = numbers
        }
    }

    func fetchNumbers(ofType type: PhoneNumberType) throws -> [PhoneNumber]? {
        defer { defaults.synchronize() }
        guard let data = defaults.data(forKey: key(for: type)) else { return nil }
        do {
            return try JSONDecoder().decode([PhoneNumber].self, from: data)
        } catch {
            throw PhoneNumberError.decodingError(error)
        }
    }
    
    func saveNumbers(_ numbers: [PhoneNumber], ofType type: PhoneNumberType) throws {
        defer { defaults.synchronize() }
        do {
            let data = try JSONEncoder().encode(numbers)
            defaults.setValue(data, forKey: key(for: type))
        } catch {
            throw PhoneNumberError.encodingError(error)
        }
    }
}
