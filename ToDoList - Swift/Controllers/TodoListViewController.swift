//
//  ViewController.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 2/18/24.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    
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
    
    //MARK: - TableView Delegate Methods
    // fired whenever we click on any cell in the tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sets the done property on the current item in the itemArray to the opposite of what it is right now.
        //if it's true it becomes false. If it's false, it becomes true. All done by using the NOT(!) operator
        //This line of code changes the title to Completed when you click on the item
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on this UIAlert
            //add whatever user wrote in the textField to the itemArray
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
    
    //MARK: - Model Manipulation Methods
    
    //This function, savedItems(), is responsible for encoding an array of items (data model) and saving it to a file using Property List serialization.
    
    func savedItems() {
        
        do {
            try context.save()
        } catch {
            print("Error printing context \(error)")
        }
        self.tableView.reloadData()
    }
    
     //this function is responsible for loading an array of Item objects from a file specified by dataFilePath, decoding the data, and storing it in the itemArray property
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        //reload our tableView so that we retrigger the cellForRowAt indexPath methods and we update our tableView with the current itemArray which contains the results from the search
        tableView.reloadData()
    }
}

// MARK: - SearchBar
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //created a predicate which specifies how we want to query our database
        //this line of code adds the query to the request
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //sort the data that comes back from the database any order we want
        //add the sortDescriptor to the request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //run the request and fetch the results
        loadItems(with: request)
    }
    
    //
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                //this line of code refers to is that is should no longer be the things that is currently selected,so no longer have the cursor and also the keyboard should go away because we are no longer editing it anymore
                    //Go back to the background, go to the original state you're in before you are activated
                searchBar.resignFirstResponder()
            }
        }
    }
}
