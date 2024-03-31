//
//  File.swift
//  
//
//  Created by Gray, Gama on 2024/03/29.
//

import Foundation

public enum ServiceType: CaseIterable {
    case deposit
    case loan
    
    var koreanName: String {
        switch self {
        case .deposit:
            return "예금"
        case .loan:
            return "대출"
        }
    }
    
    var processTime: Double {
        switch self {
        case .deposit:
            return 0.7
        case .loan:
            return 1.1
        }
    }
}
