//
//  Category.swift
//  Todoey
//
//  Created by Eduardo Santiz on 5/5/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
