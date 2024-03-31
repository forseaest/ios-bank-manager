//
//  Client.swift
//  
//
//  Created by Gray, Gama on 3/22/24.
//

import Foundation

public struct Client {
    let clientNumber: Int
    let serviceType: ServiceType
    
    public init(clientNumber: Int, serviceType: ServiceType) {
        self.clientNumber = clientNumber
        self.serviceType = serviceType
    }
}
