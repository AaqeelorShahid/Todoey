//
//  ViewController.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 12/18/21.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print (dataFilePath)
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
        items[indexPath.row].done = !items[indexPath.row].done

        tableView.reloadData()
        saveItems()

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
//
//    func deleteItem (){
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
//
//        saveItems()
//        tableView.reloadData()
//    }
//
    

    //MARK: - Add new item

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item in List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { UIAlertAction in
            // Here we're getting instance of persistent container
            
            // Here we're getting teh Item from DataModel and adding the data
            let i = Item(context: self.context)
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
    
    // Mark:- Encoder Implementation
    
    
//    func saveItems () {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(items)
//            try data.write(to: self.dataFilePath!)
//        } catch {
//            print("Error encoding item, \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
//
//    func loadItems () {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                items = try decoder.decode([item].self, from: data)
//            } catch {
//                print("Error in decoding item \(error)")
//            }
//        }
//    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
           items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

    
    
}

