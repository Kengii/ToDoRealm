//
//  Task.swift
//  ToDoRealm
//
//  Created by Владимир Данилович on 14.03.22.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
