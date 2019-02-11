//
//  CourseViewController.swift
//  BSD Gradebook iOS
//
//  Created by Alan Chu on 2/11/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import UIKit
import EDUPointServices

class CourseViewController: UIViewController {
    fileprivate var headerView: CourseHeaderViewController!
    fileprivate var tableView: CourseTableViewController!
    
    var course: Course? {
        didSet {
            self.updateView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "EMBED_TO_HEADER": self.headerView = segue.destination as! CourseHeaderViewController
        case "EMBED_TO_TABLE": self.tableView = segue.destination as! CourseTableViewController
        default: return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
    }
    
    func updateView() {
        guard headerView != nil, tableView != nil else { return }
        guard let course = self.course else { return }
        let firstMark = course.marks.first!
        
        self.title = course.title
        headerView.update(with: course.marks.first!)
    }
}
