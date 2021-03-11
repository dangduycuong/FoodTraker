//
//  SubRouter.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import  UIKit

enum Endpoint {
    case product(id: Int)
    case parser(params: [URLQueryItem])
    
    case venues(params: [URLQueryItem])
}

class RequestAPI: Network {
    var endpoint: Endpoint
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
    
    override var path: String {
        switch endpoint {
        case .product(let id):
            return "product/\(id)"
        case .parser(_):
            return "parser"
        case .venues(_):
            return "venues/56c467cb7b0d464811a42017/details"
        }
    }
    
    override var method: HTTPMethod {
        switch endpoint {
        default:
            return .get
        }
    }
    
    override var parameters: [URLQueryItem]? {
        var params: [URLQueryItem]?
        switch endpoint {
        case .product(_):
            return nil
        case .parser(let addParams):
            params = addParams
            return params
        case .venues(params: let addParams):
            params = addParams
            
        }
        return params
    }
    
    override var headerFields: [String : String]? {
        var headers = [String: String]()
        switch endpoint {
        case .parser(_):
             headers = [
                "x-rapidapi-key": "b266514becmsh63278b22c117acfp12ef2cjsn7a142a5dffa4",
                "x-rapidapi-host": "edamam-food-and-grocery-database.p.rapidapi.com"
            ]
        case .product(_):
            headers = [
                "x-rapidapi-key": "b266514becmsh63278b22c117acfp12ef2cjsn7a142a5dffa4",
                "x-rapidapi-host": "edamam-food-and-grocery-database.p.rapidapi.com"
            ]
        case .venues(_):
            headers = [
                "x-rapidapi-key": "b266514becmsh63278b22c117acfp12ef2cjsn7a142a5dffa4",
                "x-rapidapi-host": "viva-city-documentation.p.rapidapi.com"
            ]
        }

        return headers
    }
    
}
