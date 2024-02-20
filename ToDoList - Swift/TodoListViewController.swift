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
    
    //MARK - TableView Delegate Methods
    
    // fired whenever we click on any cell in the tableview
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //This just prints the number of the row that is selected
        //        print("Selected Row:  \(indexPath.row)")
        //Prints what is written in that row
        //        print("Selected Row:  \(itemArray[indexPath.row])")
        //if the tableview's current cell at the current selected indexPath already has an an accessory that is a checkmark
        //check to see if the current cell that is selected has an accessoryType of checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            // if it does, change it to none to remove the checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            //otherwise if it doesn't have a checkmark, and we selected it, then its going to add a checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
}

