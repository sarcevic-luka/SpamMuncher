//
//  PhoneNumber.swift
//  MunchCallDirectory
//
//  Created by Code Forge on 21.10.2023..
//

import Foundation
import CallKit

public struct PhoneNumber: Identifiable, Codable {
    public var id: CXCallDirectoryPhoneNumber
    public var type: PhoneNumberType
    public var name: String?

    public init(id: CXCallDirectoryPhoneNumber, type: PhoneNumberType, name: String? = nil) {
        self.id = id
        self.type = type
        self.name = name
    }
}

extension String {
    var asCXCallDirectoryPhoneNumber: CXCallDirectoryPhoneNumber {
        return Int64(self) ?? 0
    }
    
    var formattedAsPhoneNumber: String {
        let numbers = self.filter { $0.isWholeNumber }
        
        guard numbers.count == 10 else { return self }
        
        let areaCode = numbers.prefix(3)
        let middle = numbers.dropFirst(3).prefix(3)
        let last = numbers.suffix(4)
        
        return "(\(areaCode)) \(middle)-\(last)"
    }

    func toCXCallDirectoryPhoneNumber() -> CXCallDirectoryPhoneNumber {
        // Remove all non-numeric characters from the string
        let cleanedString = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Convert the cleaned string to CXCallDirectoryPhoneNumber (Int64)
        return CXCallDirectoryPhoneNumber(cleanedString) ?? 0
    }
}
