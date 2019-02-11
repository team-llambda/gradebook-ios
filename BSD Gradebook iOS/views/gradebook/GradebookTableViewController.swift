//
//  GradebookTableViewController.swift
//  BSD Gradebook iOS
//
//  Created by Alan Chu on 2/6/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import UIKit
import CoreData
import EDUPointServices

class GradebookTableViewController: UITableViewController {
    var courses: [Course]? {
        didSet {
            DispatchQueue.main.async {
                UIView.transition(with: self.tableView, duration: 0.25, options: .curveEaseInOut, animations: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @IBAction func didPressReload(_ sender: Any? = nil) {
        self.loadGradebook()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SELECTED_COURSE_ROW_TO_COURSEVC" {
            guard let destinationVC = segue.destination as? CourseViewController,
                let indexPath = self.tableView.indexPathForSelectedRow else {
                    return
            }
            
            destinationVC.course = self.courses![indexPath.row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = GradebookTableViewCell.MinimumCellHeight
    }

    func loadGradebook() {
        services.processWebRequest(methodToRun: .gradebook(reportingPeriod: nil), type: Gradebook.self).then { gradebook in
            self.courses = Array(gradebook.courses).sorted {
                guard let lhs = $0.period, let rhs = $1.period else { return false }
                return lhs < rhs
            }
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let course = self.courses?[indexPath.row] else {
            fatalError("Debug me here")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: GradebookTableViewCell.ReuseIdentifier, for: indexPath) as! GradebookTableViewCell
        
        cell.set(course: course)
        return cell
    }
}
