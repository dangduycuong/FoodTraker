//
//  MealModel.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/9/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import RealmSwift

class MealModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var pathPhoto = ""
    @objc dynamic var reviewContent = ""
    @objc dynamic var rating: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
