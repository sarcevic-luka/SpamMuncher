//
//  PhoneNumberType.swift
//  MunchCallDirectory
//
//  Created by Code Forge on 21.10.2023..
//

import Foundation

public enum PhoneNumberType: String, Codable, CaseIterable {
    case blocked = "Blocked"
    case suspicious = "Suspicious"
}
