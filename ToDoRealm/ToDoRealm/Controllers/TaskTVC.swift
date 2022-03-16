//
//  TaskTVC.swift
//  ToDoRealm
//
//  Created by Владимир Данилович on 14.03.22.
//

import UIKit
import RealmSwift

class TaskTVC: UITableViewController {
    
    var currentTasksList: TaskList!
    
    private var notCompleted: Results<Task>!
    private var comletedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(acAddandUpdatesTs))
                 self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
        title = currentTasksList.name
        filteringTasksInSection()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? notCompleted.count : comletedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Not Complete TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let task = indexPath.section == 0 ? notCompleted[indexPath.row] : comletedTasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? notCompleted[indexPath.row] : comletedTasks[indexPath.row]
        
        let deleteContext = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task)
            self.filteringTasksInSection()
        }
        let editContext = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.acAddandUpdatesT(task)
            self.filteringTasksInSection()
        }
        let doneContext = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
            StorageManager.doneTask(task)
            self.filteringTasksInSection()
        }
        editContext.backgroundColor = .blue
        doneContext.backgroundColor = .green
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteContext, editContext, doneContext])
        
        return swipeAction
    }
    
    private func filteringTasksInSection() {
        notCompleted = currentTasksList.tasks.filter("isComplete = false")
        comletedTasks = currentTasksList.tasks.filter("isComplete = true")
        tableView.reloadData()
    }

    @objc private func acAddandUpdatesTs() {
        acAddandUpdatesT()
    }
    
    private func acAddandUpdatesT(_ taskName: Task? = nil) {
        let title = "Task value"
        let massege = taskName == nil ? "Please insert list name" : "Please edit list name"
        let doneBtnName = taskName == nil ? "Save" : "Update"

        let alertController = UIAlertController(title: title, message: massege, preferredStyle: .alert)

        var alertTextField: UITextField!
        var noteTextField: UITextField!

        let saveActn = UIAlertAction(title: doneBtnName, style: .default) { _ in
            guard let newTask = alertTextField.text, !newTask.isEmpty else { return }
            if let taskName = taskName {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                StorageManager.editTask(taskName, newNameTask: newTask, newNote: newNote)
            } else {
                StorageManager.editTask(taskName, newNameTask: newTask, newNote: "")
            }
                self.filteringTasksInSection()
            } else {
                let task = Task()
                task.name = newTask
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = note
                }
                StorageManager.saveTask(self.currentTasksList, task: task)
                self.filteringTasksInSection()
            }
        }
        let cancelActn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveActn)
        alertController.addAction(cancelActn)
        alertController.addTextField { textField in
            noteTextField = textField
            if let taskName = taskName {
                noteTextField.text = taskName.note
            }
                noteTextField.placeholder = "Note"
        }
        
        alertController.addTextField { textField in
            alertTextField = textField
        if let taskName = taskName {
            alertTextField.text = taskName.name
        }
            alertTextField.placeholder = "List Name"
        }

        present(alertController, animated: true)
    }
}

