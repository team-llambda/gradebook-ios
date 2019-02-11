//
//  GradebookTableViewCell.swift
//  BSD Gradebook iOS
//
//  Created by Alan Chu on 2/7/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import UIKit
import EDUPointServices

class GradebookTableViewCell: UITableViewCell {
    static let ReuseIdentifier = "GradebookTableViewCell_ReuseIdentifier"
    static let MinimumCellHeight: CGFloat = 72
    
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    public func set(course: Course) {
        self.periodLabel.text = course.period
        self.classNameLabel.text = course.title
        self.teacherLabel.text = course.staff
        
        self.scoreLabel.text = course.marks.first?.calculatedScoreAsPercentage ?? "--"
    }
}
