//
//  EDUPMark.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/3/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import CoreData

@objc(Mark)
public class Mark: NSManagedObject, Decodable {
    public enum CodingKeys: String, CodingKey {
        case name = "MarkName"
        case calculatedScoreString = "CalculatedScoreString"
        case calculatedScoreRaw = "CalculatedScoreRaw"
        case gradeCalculation = "AssignmentGradeCalc"
        case assignments = "Assignments"
    }
    
    @NSManaged public var name: String
    @NSManaged public var calculatedScoreString: String
    @NSManaged public var calculatedScoreRaw: String
    @NSManaged public var assignments: Set<Assignment>
    
    @NSManaged public var course: Course
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Mark", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.calculatedScoreString = try container.decode(String.self, forKey: .calculatedScoreString)
        self.calculatedScoreRaw = try container.decode(String.self, forKey: .calculatedScoreRaw)
        
        // ======= Assignments =======
        if container.contains(.assignments) {
            let assignmentsContainer = try container.nestedContainer(keyedBy: AnyKey.self, forKey: .assignments)
            let assignments = try assignmentsContainer.decode([Assignment].self, forKey: AnyKey(stringValue: "Assignment"))
            assignments.indices.forEach { assignments[$0].mark = self }
            
            self.assignments = Set<Assignment>(assignments)
        } else {
            self.assignments = []
        }
    }
}
