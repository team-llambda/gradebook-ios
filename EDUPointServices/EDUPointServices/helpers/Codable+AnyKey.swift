//
//  Codable+AnyKey.swift
//  EDUPointServices
//
//  Created by Alan Chu on 1/30/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
