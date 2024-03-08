//
//  Item.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 2/27/24.
//

import Foundation
import UIKit

//Codable means - specifies that a particular class and all of their objects conform to both the encodable and decodable protocols
class Item: Codable {
    
    var title: String = ""
    var done: Bool = false 
}
