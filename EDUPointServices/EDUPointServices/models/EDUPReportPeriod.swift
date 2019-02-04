//
//  EDUPReportPeriod.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/3/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import CoreData

@objc(ReportPeriod)
public class ReportPeriod: NSManagedObject, Decodable {
    public enum CodingKeys: String, CodingKey {
        case index = "Index"
        case gradePeriod = "GradePeriod"
        case startDate = "StartDate"
        case endDate = "EndDate"
    }
    
    @NSManaged public var index: Int16
    @NSManaged public var gradePeriod: String
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    
    @NSManaged public var gradebook: Gradebook
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ReportPeriod", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.index = try container.decode(Int16.self, forKey: .index)
        self.gradePeriod = try container.decode(String.self, forKey: .gradePeriod)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
    }
}
