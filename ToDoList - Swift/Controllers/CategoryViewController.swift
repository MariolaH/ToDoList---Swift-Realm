//
//  CategoryViewController.swift
//  ToDoList - Swift
//
//  Created by Mariola Hullings on 3/25/24.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    lazy var realm = try! Realm()
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            // Perform migration if needed
            let config = Realm.Configuration(schemaVersion: 11, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: Item.className()) { oldObject, newObject in
                        newObject!["dateCreated"] = Date()
                    }
                }
            })
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error)")
        }
        loadCategories()
        tableView.separatorStyle = .none
        title = "To Do List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation does not exist")
        }
        navBar.backgroundColor = .white
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //This line unwraps an optional category from the categories array at the specified indexPath.row. If categories is not nil and contains a valid category at the given index, the if block is executed.
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
                cell.backgroundColor = categoryColor
                cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error print category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
//        super.updateModel(at: indexPath)
        if let cateroryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(cateroryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            //whatever the user entered into that textfield inside the alert is going to be the name of the new category
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField{ (field) in
            textField = field
            field.placeholder = "Add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
}
