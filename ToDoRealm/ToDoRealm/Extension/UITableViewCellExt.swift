//
//  UITableViewCellExt.swift
//  ToDoRealm
//
//  Created by Владимир Данилович on 16.03.22.
//

import Foundation
import UIKit

extension UITableViewCell {
    func configure(with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false")
        let completedTask = taskList.tasks.filter("isComplete = true")
        
        textLabel?.text = taskList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .darkGray
        } else if !completedTask.isEmpty {
            detailTextLabel?.text = "✅"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .darkGray
        }
    }
}
