//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eduardo Santiz on 5/4/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    lazy var realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        loadData()
    }
    
    //MARK: - TableView Datasource Methods.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.backgroundColorCell) else { fatalError() }
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
            if !category.items.isEmpty {
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods.
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while saving context, \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    func loadData() {
        categoryArray = realm.objects(Category.self)
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe.
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            if category.items.isEmpty {
                do {
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                } catch {
                    print("Error deleting the Category, \(error.localizedDescription)")
                }
            } else {
                let alert = UIAlertController(title: "Todoey", message: "\(category.name) has items \nIt can't be deleted.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)

                alert.addAction(action)

                self.present(alert, animated: true, completion: nil)

                self.tableView.reloadData()
            }
        }
    }
    
    override func updateModelWithSwipe(at indexPath: IndexPath) -> Bool {
        if (categoryArray?[indexPath.row].items.isEmpty)! {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Add new Cathegories.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategory = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if newCategory.hasText, let newCategory = newCategory.text {
                let category = Category()
                
                category.name = newCategory
                category.backgroundColorCell = UIColor.randomFlat.hexValue()
                
                self.save(category: category)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add a new category"
            newCategory = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
