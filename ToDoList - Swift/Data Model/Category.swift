//
//  Category.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 4/3/24.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    //forward relationship, each category has a list of items
    let items = List<Item>()
}
