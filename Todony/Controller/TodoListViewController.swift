//
//  ViewController.swift
//  Todony
//
//  Created by MalikHassnain on 01/06/2019.
//  Copyright © 2019 MalikHassnain. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var selectedCategory : Category? {
        didSet{
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems()
        }
    }
    var itemArray  = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        let item1 =  Item()
//        item1.title  = "Ios Project"
//        itemArray.append(item1)
        
    
        
//        if let item = defaults.array(forKey: "TodoListItemArray") as? [Item] {
//            itemArray = item
//        }
        
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
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
         
        
            self.saveItems()
//        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType  == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//         }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
   
  //MARK add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert  = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user click the add item on our UIAlert
           
          
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }  
    
    
    //MARK Model Menupulation Methods.
    func saveItems(){
        do{
            try self.context.save()
        }catch{
            print("Error saving context \(error)")
        }
        //            self.defaults.set(self.itemArray, forKey: "TodoListItemArray")
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)
      
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
            print(itemArray)
        }catch{
            print("Error fecting data from Context \(error)")
        }
        
        tableView.reloadData()
    }

   
    
}

//MARK: - Search bar metods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
