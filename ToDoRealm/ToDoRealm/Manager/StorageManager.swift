//
//  StorageManager.swift
//  ToDoRealm
//
//  Created by Владимир Данилович on 14.03.22.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {

    static func deleteAll() {
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch {
            print("deleteAll error")
        }
    }

    static func saveTaskList(tasksList: TaskList) {
        do {
            try realm.write({
                realm.add(tasksList)
            })
        } catch {
            print("add error")
        }
    }

    static func deleteList(tasksList: TaskList) {
        do {
            try realm.write({
                let tasks = tasksList.tasks
                realm.delete(tasks)
                realm.delete(tasksList)
            })
        } catch {
            print("delete error")
        }
    }

    static func editList(tasksList: TaskList, newListName: String, comlition: @escaping () -> ()) {
        do {
            try realm.write({
                tasksList.name = newListName
                comlition()
            })
        } catch {
            print("edit error")
        }
    }
    
    static func doneList(tasksList: TaskList, comlition: @escaping () -> ()) {
        do {
            try realm.write({
                tasksList.tasks.setValue(true, forKey: "isComplete")
            })
        } catch {
            print("done error")
        }
    }
    
    static func saveTask(_ tasksList: TaskList, task: Task) {
        do {
            try realm.write({
                tasksList.tasks.append(task)
            })
        } catch {
            print("add error")
        }
    }
    
    static func editTask(_ task: Task, newNameTask: String, newNote: String) {
        do {
            try realm.write({
                task.name = newNameTask
                task.note = newNote
            })
        } catch {
            print("edit error")
        }
    }
    
    static func deleteTask(_ task: Task) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch  {
            print("delete error")
        }
    }
    
    static func doneTask(_ task: Task) {
        try! realm.write({
            task.isComplete.toggle()
        })
    }
}
