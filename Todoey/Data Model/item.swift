//
//  item.swift
//  Todoey
//
//  Created by Shahid Aaqeel on 1/3/22.
//

import Foundation


class item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
