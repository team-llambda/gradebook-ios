//
//  TestENVs.swift
//  EDUPointServicesTests
//
//  Created by Alan Chu on 2/3/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import Foundation

enum TestENVs: String {
    case edupointUserID
    case edupointPassword
    case edupointBaseURL
    
    var value: String? {
        return ProcessInfo.processInfo.environment[rawValue]
    }
}
