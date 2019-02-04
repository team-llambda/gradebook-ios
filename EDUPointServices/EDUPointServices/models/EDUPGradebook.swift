//
//  EDUPGradebook.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/3/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import CoreData

@objc(Gradebook)
public class Gradebook: NSManagedObject, Decodable {
    public enum CodingKeys: String, CodingKey {
        case Courses, ReportingPeriods
    }
    
    @NSManaged public var courses: Set<Course>
    @NSManaged public var reportingPeriods: Set<ReportPeriod>
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Gradebook", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: AnyKey.self)
        let gradebookContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: AnyKey(stringValue: "Gradebook"))
        
        // ======= Courses =======
        let coursesContainer = try gradebookContainer.nestedContainer(keyedBy: AnyKey.self, forKey: .Courses)
        
        let courses = try coursesContainer.decode([Course].self, forKey: AnyKey(stringValue: "Course"))
        courses.indices.forEach { courses[$0].gradebook = self }
        
        self.courses = Set<Course>(courses)
        
        // ======= Reporting Periods =======
        let reportingPeriodsContainer = try gradebookContainer.nestedContainer(keyedBy: AnyKey.self, forKey: .ReportingPeriods)
        
        let reportPeriods = try reportingPeriodsContainer.decode([ReportPeriod].self, forKey: AnyKey(stringValue: "ReportPeriod"))
        reportPeriods.indices.forEach { reportPeriods[$0].gradebook = self }
        
        self.reportingPeriods = Set<ReportPeriod>(reportPeriods)
    }
}
