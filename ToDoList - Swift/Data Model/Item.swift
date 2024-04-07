//
//  Item.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 4/3/24.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated = Date()
    //reverse category, each item has a parentCategory that is of type Category and comes from the property items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
