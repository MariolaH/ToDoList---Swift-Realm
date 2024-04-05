//
//  ViewController.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 2/18/24.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        //everthing in the didSet {} is going to happen as soon as selected category gets set with a value
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview Datasource Methods
    
    //function for specifying the number of rows in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return todoItems?.count ?? 1
    }
    
    
    //function responsible for specifying what a cell should display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        // for: indexPath - current indexPath that the tableView is looking to populate
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // Set the textLabel of the cell to the item
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    // fired whenever we click on any cell in the tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = todoItems?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                } catch {
                    print("Erroe deleting, \(error)")
                }
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button on this UIAlert
            //add whatever user wrote in the textField to the itemArray
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items,\(error)")
                }
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
    
    //MARK: - Model Manipulation Methods
    
    //This function, savedItems(), is responsible for encoding an array of items (data model) and saving it to a file using Property List serialization.
    
    
    //this function is responsible for loading an array of Item objects from a file specified by dataFilePath, decoding the data, and storing it in the itemArray property
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //reload our tableView so that we retrigger the cellForRowAt indexPath methods and we update our tableView with the current itemArray which contains the results from the search
        tableView.reloadData()
    }
}

// MARK: - SearchBar
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        //created a predicate which specifies how we want to query our database
//        //this line of code adds the query to the request
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        //sort the data that comes back from the database any order we want
//        //add the sortDescriptor to the request
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        //run the request and fetch the results
//        loadItems(with: request, predicate: predicate)
//    }
//
//    //
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                //this line of code refers to is that is should no longer be the things that is currently selected,so no longer have the cursor and also the keyboard should go away because we are no longer editing it anymore
//                    //Go back to the background, go to the original state you're in before you are activated
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
