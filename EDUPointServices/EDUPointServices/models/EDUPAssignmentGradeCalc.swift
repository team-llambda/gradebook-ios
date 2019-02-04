//
//  EDUPAssignmentGradeCalc.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/3/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import CoreData

@objc(AssignmentGradeCalc)
public class AssignmentGradeCalc: NSManagedObject, Decodable {
    public enum CodingKeys: CodingKey {
        case `Type`, Weight
    }
    
    @NSManaged public var type: String
    @NSManaged public var weight: Double
    
    @NSManaged public var mark: Mark?
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AssignmentGradeCalc", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(String.self, forKey: .Type)
        self.weight = try container.decode(Double.self, forKey: .Weight)
    }
}
