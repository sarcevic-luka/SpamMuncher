//
//  PhoneNumberManager.swift
//  SpamMuncher
//
//  Created by Code Forge on 12.10.2023..
//

import Foundation

// Class that will manage adding, fetching and removing phone numbers using UserDefaults
struct PhoneNumber: Identifiable, Codable {
    var id: Int64
    var label: String
}

enum PhoneNumberType: String {
    case blocked
    case suspicious
}

final class PhoneNumberManager: ObservableObject {
    
    static let shared = PhoneNumberManager()
    
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: "group.com.yourcompany.yourappname")
    }
    
    @Published var blockedNumbers: [PhoneNumber] = []
    @Published var suspiciousNumbers: [PhoneNumber] = []
    
    init() {
        blockedNumbers = fetchNumbers(ofType: .blocked) ?? []
        suspiciousNumbers = fetchNumbers(ofType: .suspicious) ?? []
    }
    
    private func key(for type: PhoneNumberType) -> String {
        return type.rawValue + "PhoneNumbers"
    }
    
    private func fetchNumbers(ofType type: PhoneNumberType) -> [PhoneNumber]? {
        guard let data = sharedDefaults?.data(forKey: key(for: type)) else { return nil }
        return try? JSONDecoder().decode([PhoneNumber].self, from: data)
    }
    
    private func saveNumbers(_ numbers: [PhoneNumber], ofType type: PhoneNumberType) {
        if let data = try? JSONEncoder().encode(numbers) {
            sharedDefaults?.setValue(data, forKey: key(for: type))
        }
    }
    
    func addNumber(_ number: PhoneNumber, type: PhoneNumberType) {
        var numbers = (type == .blocked) ? blockedNumbers : suspiciousNumbers
        numbers.append(number)
        saveNumbers(numbers, ofType: type)
        
        // Update published arrays
        if type == .blocked {
            blockedNumbers = numbers
        } else {
            suspiciousNumbers = numbers
        }
    }
    
    func removeNumber(_ number: PhoneNumber, type: PhoneNumberType) {
        var numbers = (type == .blocked) ? blockedNumbers : suspiciousNumbers
        numbers.removeAll { $0.id == number.id }
        saveNumbers(numbers, ofType: type)
        
        // Update published arrays
        if type == .blocked {
            blockedNumbers = numbers
        } else {
            suspiciousNumbers = numbers
        }
    }
}
