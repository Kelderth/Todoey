//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eduardo Santiz on 5/4/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

//    let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
//        if(oldSchemaVersion < 1) { }
//    })

    lazy var realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black

//        Realm.Configuration.defaultConfiguration = config
        loadData()
    }
    
    //MARK: - TableView Datasource Methods.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
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
    
    //MARK: - Add new Cathegories.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCategory = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let newCategory = newCategory.text {
                let category = Category()
                
                category.name = newCategory
                
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
