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

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        tasksLists = realm.objects(TaskList.self).sorted(byKeyPath: "name")
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(acAddandUpdatesTL))
                 self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
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
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel?.text = String(tasksList.tasks.count)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc private func acAddandUpdatesTL() {
        let title = "New List"
        let massege = "Please insert list name"
        let doneBtnName = "Save"

        let alertController = UIAlertController(title: title, message: massege, preferredStyle: .alert)

        var alertTextField: UITextField!
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }

        let saveActn = UIAlertAction(title: doneBtnName, style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            let tasksList = TaskList()
            tasksList.name = newList

            StorageManager.saveTaskList(tasksList: tasksList)
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .fade)
        }
        let cancelActn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveActn)
        alertController.addAction(cancelActn)

        present(alertController, animated: true)
    }
}
