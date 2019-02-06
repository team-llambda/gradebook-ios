//
//  CalculateMarkScore.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/4/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

/// Use this when you want to calculate the weighted score of an `AssignmentGradeCalc`.
public struct CalculateMarkScore {
    public let type: String
    public var weight: Double
    public var actualScore: Double = 0.0
    public var assignedScore: Double = 0.0
    
    public var weightedScore: Double {
        guard self.actualScore > 0 || self.assignedScore > 0 else { return 0 }
        return (self.actualScore / self.assignedScore) * self.weight
    }
    
    public init(gradeCalc: AssignmentGradeCalc) {
        self.type = gradeCalc.type
        self.weight = gradeCalc.weight
    }
    
    /// Adds the scores from the provided assignment to the total `actualScore` and `assignedScore`
    /// in this model.
    /// - precondition: `assignment.actualScore != nil`. If it is nil, then this method
    /// will not do anything.
    public mutating func add(assignment: Assignment) {
        guard let actualScore = assignment.actualScore else { return }
        
        self.actualScore += actualScore
        self.assignedScore += assignment.assignedScore
    }
}
