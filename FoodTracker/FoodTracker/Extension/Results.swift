//
//  Results.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/9/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
