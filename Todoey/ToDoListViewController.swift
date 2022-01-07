//
//  ViewController.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 12/18/21.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var items = [item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        
    }

    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if (items[indexPath.row].done == true) {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            items[indexPath.row].done = false
//            saveItems()
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            items[indexPath.row].done = true
//            saveItems()
//        }
//

  
        items[indexPath.row].done = !items[indexPath.row].done
        tableView.reloadData()
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add new item

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item in List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { UIAlertAction in
            let i = item()
            i.title = textField.text!
            i.done = false
            
            self.items.append(i)
            
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([item].self, from: data)
            } catch {
                print("Error in decoding item \(error)")
            }
        }
    }
    
    
}

