//
//  TrackListTVC.swift
//  ToDoRealm
//
//  Created by Владимир Данилович on 14.03.22.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {

    var tasksLists: Results<TaskList>!
    private var ascendingSorting = true
    var notificationToken: NotificationToken?

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        tasksLists = realm.objects(TaskList.self)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(acAddandUpdatesTLs))
                 self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
        notification()
    }

    @IBAction func sortingSControl(_ sender: UISegmentedControl) {
        ascendingSorting.toggle()
        if segmentedControl.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name", ascending: ascendingSorting)
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tasksList = tasksLists[indexPath.row]
        cell.configure(with: tasksList)
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = tasksLists[indexPath.row]
        
        let deleteContext = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteList(tasksList: currentList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContext = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.acAddandUpdatesTL(currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneContext = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
            StorageManager.doneList(tasksList: currentList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        editContext.backgroundColor = .blue
        doneContext.backgroundColor = .green
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteContext, editContext, doneContext])
        
        return swipeAction
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksTVC = segue.destination as! TaskTVC
            tasksTVC.currentTasksList = tasksList
        }
    }
    
    @objc private func acAddandUpdatesTLs() {
        acAddandUpdatesTL {
            print("")
        }
    }

    private func acAddandUpdatesTL(_ tasksList: TaskList? = nil, complition: @escaping () -> ()) {
        let title = tasksList == nil ? "New List" : "Edit List"
        let massege = "Please insert list name"
        let doneBtnName = tasksList == nil ? "Save" : "Update"

        let alertController = UIAlertController(title: title, message: massege, preferredStyle: .alert)

        var alertTextField: UITextField!
        alertController.addTextField { textField in
            alertTextField = textField
        if let listName = tasksList {
            alertTextField.text = listName.name
        }
            alertTextField.placeholder = "List Name"
        }

        let saveActn = UIAlertAction(title: doneBtnName, style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            if let tasksList = tasksList {
                StorageManager.editList(tasksList: tasksList, newListName: newList, comlition: complition)
            } else {
            let tasksList = TaskList()
            tasksList.name = newList
            
            StorageManager.saveTaskList(tasksList: tasksList)
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .fade)
            }
        }
        let cancelActn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveActn)
        alertController.addAction(cancelActn)

        present(alertController, animated: true)
    }
    
    private func notification() {
        notificationToken = tasksLists.observe { change in
            switch change {
            case .initial(_):
                print("initial element")
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("deletions\(deletions)")
                      print("insertions\(insertions)")
                      print("modifications\(modifications)")
                
                if !modifications.isEmpty {
                    var indexPathArray = [IndexPath]()
                    for row in modifications {
                        indexPathArray.append(IndexPath(row: row, section: 0))
                    }
                    self.tableView.reloadRows(at: indexPathArray, with: .fade)
                }
                
                if !deletions.isEmpty {
                    var indexPathArray = [IndexPath]()
                    for row in deletions {
                        indexPathArray.append(IndexPath(row: row, section: 0))
                    }
                    self.tableView.deleteRows(at: indexPathArray, with: .fade)
                }
                if !insertions.isEmpty {
                    var indexPathArray = [IndexPath]()
                    for row in insertions {
                        indexPathArray.append(IndexPath(row: row, section: 0))
                    }
                    self.tableView.insertRows(at: indexPathArray, with: .fade)
                }
            case .error(let error):
                print("error\(error)")
            }
        }
    }
}
