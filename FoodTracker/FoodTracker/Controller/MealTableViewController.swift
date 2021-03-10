//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/9/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class MealTableViewController: BaseViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageLabel: UILabel! {
        didSet {
            pageLabel.text = "\(filteredMeals.count)"
        }
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    var count: Int = 0 {
        didSet {
            pageLabel.text = "\(count)".language()
        }
    }
    
    var meals = [MealModel]()
    
    var filteredMeals = [MealModel]()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(Realm.Configuration.defaultConfiguration)
        
        tableView.register(MealTableViewCell.nib(), forCellReuseIdentifier: MealTableViewCell.identifier())
        
        // Use the edit button item provided by the table view controller.
        //        navigationItem.leftBarButtonItem = editButtonItem
//        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editData))
//        navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icons8-reboot"), style: .done, target: self, action: #selector(reloadMeal))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        definesPresentationContext = true
        setupLongPressGesture()
        tableView.allowsMultipleSelectionDuringEditing = true
        
        setShadowButton(button: addButton, cornerRadius: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "danh_sach_mon_an".language()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard meals.count == 0 else { return }
        showLoading()
        if let savedMeals = loadMeals() {
            hideLoading()
            meals = savedMeals
            filteredMeals = meals
        }
        count = filteredMeals.count
        tableView.reloadData()
    }
    
    @objc func editData() {
        isEditing.toggle()
    }
    
    @objc func reloadMeal() {
        if let data = loadMeals() {
            filteredMeals = data
            meals = data
            count = filteredMeals.count
            tableView.reloadData()
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    private func loadMeals() -> [MealModel]? {
        //        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
        let results = realm.objects(MealModel.self).sorted(byKeyPath: "name", ascending: true).toArray(ofType: MealModel.self)
        print(results.count)
        return results
    }
    
    @IBAction func tapNextAddMeal(_ sender: UIButton) {
        title = ""
        let vc = Storyboard.Main.newMealViewController()
        vc.count = meals.count
        navigationController?.pushViewController(vc, animated: true)
    }
    
  
}

extension MealTableViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier(), for: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = filteredMeals[indexPath.row]
        
        let path = meal.pathPhoto
        if let image = getSavedImage(named: path) {
            cell.photoImageView.image = image
        }
        //        cell.photoImageView.image = loadImageFromPath(path as NSString)
        
        
        // Set color when user touch inside (or click choose)
        let backgroudView = UIView()
        backgroudView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        cell.selectedBackgroundView = backgroudView
        //        indexPath.row % 2 == 0 ? (cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) : (cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
        cell.nameLabel.text = meal.name
        
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
}

extension MealTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let item = filteredMeals[indexPath.row]
                // edit
                try realm.write {
                    realm.delete(item)
                    reloadMeal()
                }
            } catch {
                print("Lỗi Delete đối tượng")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        title = ""
        let vc = Storyboard.Main.mealViewController()
        
        vc.meal = filteredMeals[indexPath.row]
        vc.title = "Thông tin chi tiết"
        
        vc.closureUpdate = { [weak self] data in
            let realm = try! Realm()
            realm.beginWrite()
            let listFood = realm.objects(MealModel.self)
            for item in listFood {
                if item.id == data.id {
                    item.name = data.name
                    item.pathPhoto = data.pathPhoto
                    item.reviewContent = data.reviewContent
                    item.rating = data.rating
                }
            }
            self?.filteredMeals[indexPath.row] = data
            try! self?.realm.commitWrite()
            self?.reloadMeal()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAll() {
        let results = realm.objects(MealModel.self).sorted(byKeyPath: "ten", ascending: true).toArray(ofType: MealModel.self)
        print(results.count)
        meals.removeAll()
        filteredMeals.removeAll()
        
        for item in results {
            meals.append(item)
            filteredMeals.append(item)
        }
    }
}

extension MealTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMeal()
    }
    
    func filterMeal() {
        if searchBar.text == "" {
            filteredMeals = meals
        } else {
            if let text = searchBar.text {
                filteredMeals = meals.filter { (data: MealModel) in
                    if data.name.lowercased().range(of: text.lowercased()) != nil {
                        return true
                    }
                    return false
                }
            }
        }
        count = filteredMeals.count
        tableView.reloadData()
    }
}

extension MealTableViewController {
    func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MealTableViewController.handleLongPress))
        longPress.minimumPressDuration = 0.75
        longPress.delegate = self
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                self.tableView.deselectRow(at: indexPath, animated: true)
                
                print("dang an o day", indexPath.row)
                isEditing.toggle()
            }
        }
    }
}
