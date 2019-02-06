//
//  PXPWebServices+Functions.swift
//  EDUPointServices
//
//  Created by Alan Chu on 1/30/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import Foundation

public enum PXPWebServicesFunction {
    case gradebook(reportingPeriod: Int?)
    case childList
    
    public var methodName: String {
        switch self {
        case .gradebook( _):    return "Gradebook"
        case .childList:        return "ChildList"
        }
    }
    
    public var parameters: String {
        switch self {
        case .gradebook(let reportingPeriod):
            if let period = reportingPeriod {
                return "<Parms><ChildIntID>0</ChildIntID><ReportPeriod>\(period)</ReportPeriod></Parms>"
            }
            return "<Parms><ChildIntID>0</ChildIntID></Parms>"
        case .childList:
            return ""
        }
    }
    
    public var responseType: Decodable.Type {
        switch self {
        case .gradebook(_):     return Gradebook.self
        case .childList:        return Child.self
        }
    }
}
