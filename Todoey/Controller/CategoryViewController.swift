//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 1/11/22.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var category: Results <Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.rowHeight = 80.0
    }
  
    
    //MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = category?[indexPath.row].name ?? "No Categories added"
        return cell
    }
    
    //MARK: - Category alert
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var categoryField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "Enter the category title!", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { Action in
            let newCategory = Category()
            newCategory.name = categoryField.text!
            self.saveData(category: newCategory)
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
            destinationVC.selectedCategory = category?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation
    
    func saveData(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error in saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        category = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //MARK: - Delete from Swipe Table
    
    override func updateModel(at indexpath: IndexPath) {
        super.updateModel(at: indexpath)
        deleteCategory(row: indexpath.row)
    }
    
    func deleteCategory(row: Int) {
        
        if let categoryForDeletion = category?[row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("error while deleting \(error)")
            }
        }
        
    }
    
}
