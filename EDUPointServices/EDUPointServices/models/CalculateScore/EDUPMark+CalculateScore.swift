//
//  EDUPMark+CalculateScore.swift
//  EDUPointServices
//
//  Created by Alan Chu on 2/4/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

extension Mark {
    public var calculatedScore: Double? {
        guard !self.assignments.isEmpty else { return nil }
        
        // Disregard ungraded assignments
        let gradedAssignments = self.assignments.filter { $0.actualScore != nil }
        
        if self.gradeCalculations.count <= 0 {
            let totalActualScore = gradedAssignments.reduce(0.0, { $0 + ($1.actualScore ?? 0) })
            let totalAssignedScore = gradedAssignments.reduce(0.0, { $0 + $1.assignedScore })
            
            return totalActualScore / totalAssignedScore
        }
        
        var calculations: [CalculateMarkScore] = self.gradeCalculations.map { CalculateMarkScore(gradeCalc: $0) }
        
        for assignment in gradedAssignments {
            for calculationIndex in calculations.indices {
                if assignment.type.isEmpty || calculations[calculationIndex].type == assignment.type {
                    calculations[calculationIndex].add(assignment: assignment)
                }
            }
        }
        
        // Remove empty categories
        calculations = calculations.filter { $0.actualScore != 0 && $0.assignedScore != 0 }
        
        // If the weight total of non-zero categories do not add up to 100%, scale all other weights so it's equal to 100%.
        let weightSum = calculations.reduce(0.0, { $0 + $1.weight })
        let scaleFactor = 1 / weightSum
        calculations.indices.forEach { calculations[$0].weight *= scaleFactor }
        
        let calculatedScore = calculations.reduce(0.0, { $0 + $1.weightedScore })
        guard !calculatedScore.isNaN else { return nil }
        
        return calculatedScore
    }
    
    public var calculatedScoreAsPercentage: String? {
        guard let score = calculatedScore else { return nil }
        let percentageScore = score * 100.00
        return "\(String(format: "%.2f", percentageScore))%"
    }
}
