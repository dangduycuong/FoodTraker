//
//  Storyboard.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/9/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

struct Storyboard {
    
}

extension Storyboard {
    
    struct Main {
        static let manager = UIStoryboard(name: "Main", bundle: nil)
        
        static func mealViewController() -> MealViewController {
            return manager.instantiateViewController(withIdentifier: "MealViewController") as! MealViewController
        }
        
        static func newMealViewController() -> NewMealViewController {
            return manager.instantiateViewController(withIdentifier: "NewMealViewController") as! NewMealViewController
        }
        
        static func mealTableViewController() -> MealTableViewController {
            return manager.instantiateViewController(withIdentifier: "MealTableViewController") as! MealTableViewController
        }
    }
}
