//
//  String.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/9/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

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
    
    func language() -> String{
        return VTLocalizedString.localized(key: self)
    }
    
    func localizedString() -> String {
        return LocalizationHandlerUtil.shareInstance().localizedString(self, comment: nil)
    }
    
}

//class LocalizationHandlerUtil: NSObject {
//    static let shareInstance: LocalizationHandlerUtil = LocalizationHandlerUtil()
//
//    func localizedString(_ key: String?, comment: String?) -> String? {
//        return comment
//    }
//
//    func setLanguageIdentifier(_ indentifier: String?) {
//    }
//
//    var currentLanguage: String?
//
//    var isKorean: Bool = false
//
//    var userLanguage: String?
//}
