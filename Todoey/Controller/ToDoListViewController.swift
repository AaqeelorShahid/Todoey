//
//  ViewController.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 12/18/21.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items addded"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("Error in selection \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item in List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { UIAlertAction in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let i = Item()
                        i.title = textField.text!
                        i.done = false
                        i.dataCreated = Date()
                        
                        currentCategory.items.append(i)
                        self.realm.add(i)
                    }
                } catch {
                    print("error \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Mark:- Encoder Implementation
    
    
    func saveItems (item: Item) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error in saving data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems () {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //    func saveItems(){
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Error saving context \(error)")
    //        }
    //        self.tableView.reloadData()
    //    }
    
    }

    //MARK: - Search Bar Methods
    extension ToDoListViewController: UISearchBarDelegate {
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
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

