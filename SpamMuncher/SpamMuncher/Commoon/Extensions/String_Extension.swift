//
//  String_Extension.swift
//  SpamMuncher
//
//  Created by Code Forge on 31.10.2023..
//

import Foundation
import CallKit

extension String {
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

    var formattedAsPhoneNumberWithRegion: String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+XXX XX XXXX XXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

    func toCXCallDirectoryPhoneNumber() -> CXCallDirectoryPhoneNumber {
        let cleanedString = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return CXCallDirectoryPhoneNumber(cleanedString) ?? 0
    }
}
