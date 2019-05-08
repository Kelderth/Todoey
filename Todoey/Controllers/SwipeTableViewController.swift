//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Eduardo Santiz on 5/7/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 80.0
    }
    
    //MARK: - TableView Datasource Methods.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell

    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexpath) in
            self.updateModel(at: indexpath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        
        if updateModelWithSwipe(at: indexPath) {
            options.expansionStyle = .destructive
        } else {
            options.expansionStyle = .destructive(automaticallyDelete: false)
        }
        
        return options
    }
    
    //MARK: - Update our Data Model

    func updateModel(at indexPath: IndexPath) {}
    
    func updateModelWithSwipe(at indexPath: IndexPath) -> Bool {
        return true
    }
        
}
