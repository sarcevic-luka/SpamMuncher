//
//  PhoneNumber.swift
//  MunchModel
//
//  Created by Code Forge on 30.10.2023..
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
