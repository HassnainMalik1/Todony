//
//  ViewController.swift
//  Todony
//
//  Created by MalikHassnain on 01/06/2019.
//  Copyright © 2019 MalikHassnain. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray  = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let item1 =  Item()
        item1.title  = "Ios Project"
        itemArray.append(item1)
        
        if let item = defaults.array(forKey: "TodoListItemArray") as? [Item] {
            itemArray = item
        }
        
    }

    //MARK - TABLE data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item  = itemArray[indexPath.row]
        
        cell.accessoryType  = item.done ? .checkmark : .none
        cell.textLabel?.text = item.title
        return cell
    }
    
    //MARK - Table view delegate method.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        if tableView.cellForRow(at: indexPath)?.accessoryType  == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
         }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
   
  //MARK add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert  = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user click the add item on our UIAlert
           
            let newItem = Item()
            
             newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListItemArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }  
    
    
    

}

