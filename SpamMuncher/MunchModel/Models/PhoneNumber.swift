//
//  PhoneNumber.swift
//  MunchModel
//
//  Created by Code Forge on 30.10.2023..
//

import Foundation
import CallKit

public struct PhoneNumber: Identifiable, Codable, Equatable {
    public let id: CXCallDirectoryPhoneNumber
    public let type: PhoneNumberType
    public let name: String?

    public init(
        id: CXCallDirectoryPhoneNumber,
        type: PhoneNumberType,
        name: String? = nil
    ) {
        self.id = id
        self.type = type
        self.name = name
    }
    
    public static func ==(lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type && lhs.name == rhs.name
    }
}
