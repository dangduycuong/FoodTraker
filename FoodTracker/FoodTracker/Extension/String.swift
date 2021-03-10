//
//  String.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/9/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
extension String {
    static func random(length: Int = 10) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
