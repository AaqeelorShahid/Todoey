//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 1/11/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var category = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
  
    
    //MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Category alert
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var categoryField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "Enter the category title!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { Action in
            let newCategory = Category (context: self.context)
            newCategory.name = categoryField.text
            
            self.category.append(newCategory)
            self.saveData()
            
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Category name"
            categoryField = textField
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error in saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories (with request: NSFetchRequest <Category> = Category.fetchRequest()) {
        do {
            let data = try context.fetch(request)
            category = data
        } catch {
            print("Error in loading data \(error)")
        }
        
        tableView.reloadData()
    }
    
}
