//
//  File.swift
//  
//
//  Created by JIWOONG on 2024/03/29.
//

import Foundation

public enum ServiceType: CaseIterable {
    case deposit
    case loan
    
    var koreanName: String {
        switch self {
        case .deposit :
            return "예금"
        case .loan :
            return "대출"
        }
    }
}
