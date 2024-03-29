//
//  Client.swift
//  
//
//  Created by Gray, Gama on 3/22/24.
//

import Foundation

public struct Client {
    let clientNumber: Int
    let serviceType: String
    
    public init(clientNumber: Int, serviceType: String) {
        self.clientNumber = clientNumber
        self.serviceType = serviceType
    }
}
