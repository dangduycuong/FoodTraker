//
//  EdamamFoodAndGroceryDatabaseVC.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class EdamamFoodAndGroceryDatabaseVC: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        request()
        
        showLoading()
        let params: [URLQueryItem] = [
            URLQueryItem(name: "lang", value: "zh-hans")
        ]
        RequestAPI.init(endpoint: .venues(params: params)).getData(completion: { result in
            self.hideLoading()
            switch result {
            case .success(let data):
                if let json = try? JSON(data: data) {
                    
                }
            default:
                break
            }
        })
    }
    
    func request() {
        showLoading()
        let string = "https://aliexpress-unofficial.p.rapidapi.com/product/4000886597329"
        let headers = [
            "x-rapidapi-key": "b266514becmsh63278b22c117acfp12ef2cjsn7a142a5dffa4",
            "x-rapidapi-host": "aliexpress-unofficial.p.rapidapi.com"
        ]
        let params: [URLQueryItem] = [
            URLQueryItem(name: "ingr", value: "value")
        ]
        showLoading()
        
        Network.shared.getCategorByAPI(url: string, headers: headers, method: .get, completion: { [weak self] data in
            self?.hideLoading()
            switch data {
            case .success(let data):
                if let json = try? JSON(data: data) {
                    print("Response json:\n", json as Any)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func callAPI() {
        let headers = [
            "x-rapidapi-key": "b266514becmsh63278b22c117acfp12ef2cjsn7a142a5dffa4",
            "x-rapidapi-host": "edamam-food-and-grocery-database.p.rapidapi.com"
        ]
        let string = "https://edamam-food-and-grocery-database.p.rapidapi.com/parser"
        let value = searchBar.text
        let params: [URLQueryItem] = [
            URLQueryItem(name: "ingr", value: value)
        ]
        
        BaseRouter.shared.getData(urlString: string, params: params, headers: headers, method: .get, completion: { (data: JSON) in
        })
    }

}

extension EdamamFoodAndGroceryDatabaseVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        callAPI()
        request()
        searchBar.resignFirstResponder()
    }
}
