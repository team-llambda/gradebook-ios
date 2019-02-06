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
    public enum CodingKeys: CodingKey {
        case MarkName, CalculatedScoreString, CalculatedScoreRaw, Assignments, AssignmentGradeCalc
        case GradeCalculationSummary
    }
    
    @NSManaged public var name: String
    @NSManaged public var calculatedScoreString: String
    @NSManaged public var calculatedScoreRaw: String
    
    @NSManaged public var assignments: Set<Assignment>
    @NSManaged public var gradeCalculations: Set<AssignmentGradeCalc>
    
    @NSManaged public var course: Course
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Mark", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .MarkName)
        self.calculatedScoreString = try container.decode(String.self, forKey: .CalculatedScoreString)
        self.calculatedScoreRaw = try container.decode(String.self, forKey: .CalculatedScoreRaw)
        
        // ======= Assignments =======
        if container.contains(.Assignments) {
            let assignmentsContainer = try container.nestedContainer(keyedBy: AnyKey.self, forKey: .Assignments)
            let assignments = try assignmentsContainer.decode([Assignment].self, forKey: AnyKey(stringValue: "Assignment"))
            assignments.indices.forEach { assignments[$0].mark = self }
            
            self.assignments = Set<Assignment>(assignments)
        } else {
            self.assignments = []
        }
        
        // ======= Assignment Grade Calc =======
        if let gradeSummaryContainer = try? container.nestedContainer(keyedBy: AnyKey.self, forKey: .GradeCalculationSummary) {
            var gradeCalcs = try gradeSummaryContainer.decode(Set<AssignmentGradeCalc>.self, forKey: AnyKey(stringValue: "AssignmentGradeCalc"))
            
            for calc in gradeCalcs.enumerated() {
                // Delete TOTAL grade calcs.
                guard calc.element.type != "TOTAL" else {
                    managedObjectContext.delete(gradeCalcs.remove(calc.element)!)
                    continue
                }
                
                calc.element.mark = self
            }
            
            self.gradeCalculations = gradeCalcs
        } else {
            self.gradeCalculations = []
        }
    }
}
