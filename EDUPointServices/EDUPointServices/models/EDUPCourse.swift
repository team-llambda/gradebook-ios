//
//  EDUPCourse.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/3/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import CoreData

@objc(Course)
public class Course: NSManagedObject, Decodable {
    public enum CodingKeys: String, CodingKey {
        case title = "Title"
        case period = "Period"
        case room = "Room"
        
        case staffGU = "StaffGU"
        case staff = "Staff"
        case staffEmail = "StaffEMail"
        
        case marks = "Marks"
    }
    
    @NSManaged public var title: String
    @NSManaged public var period: String?
    @NSManaged public var room: String?
    
    @NSManaged public var staffGU: String?
    @NSManaged public var staff: String?
    @NSManaged public var staffEmail: String?
    
    @NSManaged public var marks: Set<Mark>
    
    @NSManaged public var gradebook: Gradebook?
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Course", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)

        let courseContainer = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try courseContainer.decode(String.self, forKey: .title)
        self.period = try courseContainer.decodeIfPresent(String.self, forKey: .period)
        self.room = try courseContainer.decodeIfPresent(String.self, forKey: .room)
        
        self.staffGU = try courseContainer.decodeIfPresent(String.self, forKey: .staffGU)
        self.staff = try courseContainer.decodeIfPresent(String.self, forKey: .staff)
        self.staffEmail = try courseContainer.decodeIfPresent(String.self, forKey: .staffEmail)
        
        // ======= Marks =======
        let marksContainer = try courseContainer.nestedContainer(keyedBy: AnyKey.self, forKey: .marks)
        let marks = try marksContainer.decode([Mark].self, forKey: AnyKey(stringValue: "Mark"))
        marks.indices.forEach { marks[$0].course = self }
        
        self.marks = Set<Mark>(marks)
    }
}
