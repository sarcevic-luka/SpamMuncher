//
//  Mock_BlockListViewModel.swift
//  SpamMuncher
//
//  Created by Code Forge on 23.10.2023..
//

import Foundation

// Mock data for preview purposes.
extension BlockListViewModel {
    static var mock: BlockListViewModel {
        let viewModel = BlockListViewModel()
        
        let samplePhoneNumbers: [PhoneNumber] = [
            PhoneNumber(id: 1234567890, type: .blocked),
            PhoneNumber(id: 0987654321, type: .suspicious)
        ]
        
        let phoneNumberManager = PhoneNumberManager()
        samplePhoneNumbers.forEach { phoneNumberManager.addNumber($0) }
        
        return viewModel
    }
}
