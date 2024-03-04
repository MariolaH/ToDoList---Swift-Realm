//
//  ViewController.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 2/18/24.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Mike"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Mike"
        itemArray.append(newItem3)
        
    
        
//        if let items  = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK - TableView Delegate Methods
    // fired whenever we click on any cell in the tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sets the done property on the current item in the itemArray to the opposite of what it is right now.
        //if it's true it becomes false. If it's false, it becomes true. All done by using the NOT(!) operator
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else { itemArray[indexPath.row].done = false
//        }
        
        //this forces the table view to call its Datasource Method again, so that it reloads the data that's meant to be inside
        tableView.reloadData()
        
        //This just prints the number of the row that is selected
        //        print("Selected Row:  \(indexPath.row)")
        //Prints what is written in that row
        //        print("Selected Row:  \(itemArray[indexPath.row])")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on this UIAlert
            //add whatever user wrote in the textField to the itemArray
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            //tableView.reloadData() - reloads the rows and the section of the tabeView, taking into account the new data that has been added to the itemArray
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.itemArray)
                try data.write(to: self.dataFilePath!)
            } catch {
                print("Error encoding item array, \(error)")
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
}

