//
//  CallProcessor.swift
//  SpamMuncher
//
//  Created by Code Forge on 07.10.2023..
//

import Foundation

final class CallProcessor {
    static let shared = CallProcessor()
    
    // TODO: Move those to a database
    private let suspiciousNumbers = ["425-950-1212"]
    private let scamNumbers = ["253-950-1212"]
    
    func processIncomingCall(call: Call) -> Call.CallType {
        if suspiciousNumbers.contains(call.callerNumber) {
            return .suspicious
        } else if scamNumbers.contains(call.callerNumber) {
            return .scam
        } else {
            return .normal
        }
    }
}
