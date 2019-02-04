//
//  EDUPChild.swift
//  EDUPointServices
//
//  Created by Alan Chu on 1/28/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import Foundation
import CoreData

@objc(Child)
public class Child: NSManagedObject, Decodable {
    public enum CodingKeys: String, CodingKey {
        case StudentGU, ChildName, Grade, OrganizationName
    }
    
    @NSManaged public var studentGU: String
    @NSManaged public var childName: String
    @NSManaged public var grade: String
    @NSManaged public var organizationName: String
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Child", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: AnyKey.self)
        let childListContainer = try container.nestedContainer(keyedBy: AnyKey.self, forKey: AnyKey(stringValue: "ChildList"))
        let childContainer = try childListContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: AnyKey(stringValue: "Child"))
        
        self.studentGU = try childContainer.decode(String.self, forKey: .StudentGU)
        self.childName = try childContainer.decode(String.self, forKey: .ChildName)
        self.grade = try childContainer.decode(String.self, forKey: .Grade)
        self.organizationName = try childContainer.decode(String.self, forKey: .OrganizationName)
    }
}
