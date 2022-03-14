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
}
