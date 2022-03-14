//
//  TaskList.swift
//  ToDoRealm
//
//  Created by Владимир Данилович on 14.03.22.
//

import Foundation
import RealmSwift

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
