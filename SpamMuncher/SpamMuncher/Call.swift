//
//  Call.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import SwiftUI

// Define a data model to represent incoming calls. Each call should have properties like caller name/number, call type (normal, suspicious, scam), and a timestamp.
struct Call: Identifiable {
    enum CallType: String, CaseIterable, Equatable {
        case normal
        case suspicious
        case scam
        
        var textColor: Color {
            switch self {
            case .normal:
                return Color.primary
            case .suspicious:
                return Color.warningColor
            case .scam:
                return Color.alertColor
            }
        }
        
        var description: String {
            switch self {
            case .normal:
                return "Normal"
            case .suspicious:
                return "Suspicious"
            case .scam:
                return "Scam"
            }
        }
    }
    
    var callerName: String
    var callerNumber: String
    var callType: CallType
    var timestamp: Date
    var id: String = UUID().uuidString
    
    var callTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: timestamp)
    }
}

