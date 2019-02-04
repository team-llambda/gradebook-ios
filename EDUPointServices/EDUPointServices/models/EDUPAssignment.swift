//
//  EDUPAssignment.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/3/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import CoreData

@objc(Assignment)
public class Assignment: NSManagedObject, Decodable {
    public enum CodingKeys: String, CodingKey {
        case GradebookID, Measure, Date, DueDate, `Type`, Notes, Points
    }
    
    @NSManaged public var gradebookID: String?
    @NSManaged public var measure: String?
    @NSManaged public var date: Date?
    @NSManaged public var dueDate: Date?
    
    @NSManaged public var type: String
    @NSManaged public var assignedScore: Double
    
    // obj-c cannot do optional scalar automatically, so manually get the optional value.
    // Source: http://aplus.rs/2017/handling-core-data-optional-scalar-attributes/
    public var actualScore: Double? {
        get {
            willAccessValue(forKey: "actualScore")
            defer { didAccessValue(forKey: "actualScore") }
            
            return primitiveValue(forKey: "actualScore") as? Double
        }
        set {
            willChangeValue(forKey: "actualScore")
            defer { didChangeValue(forKey: "actualScore") }
            
            guard let value = newValue else {
                setPrimitiveValue(nil, forKey: "actualScore")
                return
            }
            setPrimitiveValue(value, forKey: "actualScore")
        }
    }
    
    @NSManaged public var notes: String?
    
    @NSManaged public var isArbitrary: Bool
    
    @NSManaged public var mark: Mark?
    
    required public convenience init(from decoder: Decoder) throws {
        let managedObjectContext = EDUPStorageController.shared.container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Assignment", in: managedObjectContext)!
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.gradebookID = try container.decodeIfPresent(String.self, forKey: .GradebookID)
        self.type = try container.decode(String.self, forKey: .Type)
        self.measure = try container.decodeIfPresent(String.self, forKey: .Measure)
        self.notes = try container.decodeIfPresent(String.self, forKey: .Notes)
        
        self.date = try container.decodeIfPresent(Date.self, forKey: .Date)
        self.dueDate = try container.decodeIfPresent(Date.self, forKey: .DueDate)
        
        self.isArbitrary = false
        
        if let points = try container.decodeIfPresent(String.self, forKey: .Points),
            let scores = parseScores(points) {
            self.assignedScore = scores.assignedScore
            self.actualScore = scores.actualScore
        } else {
            self.assignedScore = 0
        }
    }
}

fileprivate func parseScores(_ scoreString: String) -> (assignedScore: Double, actualScore: Double?)? {
    guard !scoreString.isEmpty else { return nil }
    
    guard let delimiterIndex = scoreString.firstIndex(of: "/") else {
        if let assignedScoreString = scoreString.split(separator: " ").first,
            let assignedScore = Double(assignedScoreString) {
            return (assignedScore: assignedScore, actualScore: nil)
        }
        
        return nil
    }
    
    let assignedString = scoreString[scoreString.index(delimiterIndex, offsetBy: 2)..<scoreString.endIndex]
    let actualString = scoreString[scoreString.startIndex..<scoreString.index(delimiterIndex, offsetBy: -1)]
    
    guard let assignedScore = Double(assignedString),
        let actualScore = Double(actualString) else {
            return nil
    }
    
    return (assignedScore: assignedScore, actualScore: actualScore)
}
