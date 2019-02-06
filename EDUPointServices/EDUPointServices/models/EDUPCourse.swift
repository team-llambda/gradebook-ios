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
        case Title, Period, Room, StaffGU, Staff, StaffEMail, Marks
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

        self.title = try courseContainer.decode(String.self, forKey: .Title)
        self.period = try courseContainer.decodeIfPresent(String.self, forKey: .Period)
        self.room = try courseContainer.decodeIfPresent(String.self, forKey: .Room)
        
        self.staffGU = try courseContainer.decodeIfPresent(String.self, forKey: .StaffGU)
        self.staff = try courseContainer.decodeIfPresent(String.self, forKey: .Staff)
        self.staffEmail = try courseContainer.decodeIfPresent(String.self, forKey: .StaffEMail)
        
        // ======= Marks =======
        let marksContainer = try courseContainer.nestedContainer(keyedBy: AnyKey.self, forKey: .Marks)
        let marks = try marksContainer.decode(Set<Mark>.self, forKey: AnyKey(stringValue: "Mark"))
        marks.indices.forEach { marks[$0].course = self }
        
        self.marks = marks
    }
}
