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
    public var number: Int64
    public var label: String

    public init(id: CXCallDirectoryPhoneNumber, number: Int64, label: String) {
        self.id = id
        self.number = number
        self.label = label
    }
}
