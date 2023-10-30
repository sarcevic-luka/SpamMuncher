//
//  PhoneNumberManager.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import Foundation
import Combine

protocol PhoneNumberManaging {
    var blockedNumbers: [PhoneNumber] { get set }
    var suspiciousNumbers: [PhoneNumber] { get set }
    
    var blockedNumbersPublisher: AnyPublisher<[PhoneNumber], Never> { get }
    var suspiciousNumbersPublisher: AnyPublisher<[PhoneNumber], Never> { get }

    func addNumber(_ number: PhoneNumber)
    func removeNumber(_ number: PhoneNumber)
}


public final class PhoneNumberManager: ObservableObject, PhoneNumberManaging {
    public enum Action {
        case add, remove
    }
    
    @Published public internal(set) var blockedNumbers: [PhoneNumber] = []
    @Published public internal(set) var suspiciousNumbers: [PhoneNumber] = []

    public var blockedNumbersPublisher: AnyPublisher<[PhoneNumber], Never> {
        $blockedNumbers.eraseToAnyPublisher()
    }
    
    public var suspiciousNumbersPublisher: AnyPublisher<[PhoneNumber], Never> {
        $suspiciousNumbers.eraseToAnyPublisher()
    }

    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults(suiteName: "group.luka.sarcevic.SpamMuncher")!) {
        self.defaults = defaults
        blockedNumbers = (try? fetchNumbers(ofType: .blocked)) ?? []
        suspiciousNumbers = (try? fetchNumbers(ofType: .suspicious)) ?? []

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
    enum PhoneNumberError: Error {
        case decodingError(Error)
        case encodingError(Error)
    }

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
        } catch let error as PhoneNumberError {
            // Handle or log error
            print(error)
        } catch {
            print("Error saving numbers for \(number.type.rawValue): \(error)")
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
        objectWillChange.send()
    }

    func fetchNumbers(ofType type: PhoneNumberType) throws -> [PhoneNumber]? {
        guard let data = defaults.data(forKey: key(for: type)) else { return nil }
        do {
            return try JSONDecoder().decode([PhoneNumber].self, from: data)
        } catch {
            throw PhoneNumberError.decodingError(error)
        }
    }
    
    func saveNumbers(_ numbers: [PhoneNumber], ofType type: PhoneNumberType) throws {
        do {
            let data = try JSONEncoder().encode(numbers)
            defaults.setValue(data, forKey: key(for: type))
        } catch {
            throw PhoneNumberError.encodingError(error)
        }
    }
}
