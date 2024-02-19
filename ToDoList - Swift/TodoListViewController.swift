//
//  ViewController.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 2/18/24.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggs", "Buy Banana"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - Tableview Datasource Methods
    
    //function for specifying the number of rows in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return itemArray.count
    }
    
    //function responsible for specifying what a cell should display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        // for: indexPath - current indexPath that the tableView is looking to populate
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // Set the textLabel of the cell to the item
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

}

