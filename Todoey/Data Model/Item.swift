//
//  Item.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 1/12/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var done: Bool = false
    @objc dynamic var title: String = ""
    @objc dynamic var dataCreated: Date?
    
    // Each item has reverse relationship with type category and it comes from items
    var parentCategory = LinkingObjects.init(fromType: Category.self, property: "items")
}
