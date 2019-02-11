//
//  CourseHeaderViewController.swift
//  BSD Gradebook iOS
//
//  Created by Alan Chu on 2/11/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import UIKit
import EDUPointServices

class CourseHeaderViewController: UIViewController {
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func update(with mark: Mark) {
        courseNameLabel.text = mark.course.title
        teacherNameLabel.text = mark.course.staff
        scoreLabel.text = mark.calculatedScoreAsPercentage ?? "--"
    }
}
