//
//  Category.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 1/12/22.
//

import Foundation
import RealmSwift

class Category:Object {
    @objc dynamic var name: String = ""
    
    //Each category has list of items - Forward Relationship
    let items = List<Item>()
}
