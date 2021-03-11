//
//  URL.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Apple. All rights reserved.
// How do I convert url.query to a dictionary in Swift?
//https://stackoverflow.com/questions/46603220/how-do-i-convert-url-query-to-a-dictionary-in-swift
import Foundation

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}
