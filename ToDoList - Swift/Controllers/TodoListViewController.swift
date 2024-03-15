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
     
        loadItems()   
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
        
        savedItems()

//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else { itemArray[indexPath.row].done = false
//        }
        
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
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = Item(context: context)
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            //tableView.reloadData() - reloads the rows and the section of the tabeView, taking into account the new data that has been added to the itemArray
            
            self.savedItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    
    //This function, savedItems(), is responsible for encoding an array of items (data model) and saving it to a file using Property List serialization.
    
    func savedItems() {
        
        do {

        } catch {

        }
        self.tableView.reloadData()
    }
    
    // this function is responsible for loading an array of Item objects from a file specified by dataFilePath, decoding the data, and storing it in the itemArray property
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

