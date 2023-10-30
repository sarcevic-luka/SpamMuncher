//
//  PhoneNumber.swift
//  MunchCallDirectory
//
//  Created by Code Forge on 21.10.2023..
//

import Foundation
import CallKit

extension String {
    var asCXCallDirectoryPhoneNumber: CXCallDirectoryPhoneNumber {
        return Int64(self) ?? 0
    }
    
    var formattedAsPhoneNumber: String {
        let numbers = self.filter { $0.isWholeNumber }
        
        let areaCode = numbers.prefix(3)
        let middle = numbers.dropFirst(3).prefix(3)
        let last = numbers.dropFirst(6)
        
        switch numbers.count {
        case 1...3:
            return "(\(areaCode))"
        case 4...6:
            return "(\(areaCode)) \(middle)"
        default:
            return "(\(areaCode)) \(middle)-\(last)"
        }
    }

    func toCXCallDirectoryPhoneNumber() -> CXCallDirectoryPhoneNumber {
        // Remove all non-numeric characters from the string
        let cleanedString = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Convert the cleaned string to CXCallDirectoryPhoneNumber (Int64)
        return CXCallDirectoryPhoneNumber(cleanedString) ?? 0
    }
}
