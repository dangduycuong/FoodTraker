//
//  NewMealViewController.swift
//  FoodTracker
//
//  Created by Dang Duy Cuong on 3/9/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import os.log
import RealmSwift

class NewMealViewController: BaseViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var reViewTextView: UITextView!
    
    let realm = try! Realm()
    var placeHolder: UILabel!
    let imagePicker = UIImagePickerController()
    var path: String = ""
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        imagePicker.delegate = self
        
        placeHolder = UILabel()
        setPlaceholder(textView: reViewTextView, label: placeHolder, text: "Nhận xét...")
        reViewTextView.delegate = self
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icons8-save"), style: .done, target: self, action: #selector(saveMeal))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "them_moi_mon_an".language()
    }
    
    @objc func saveMeal() {
        if checkFood() == false {
            return
        }
        let meal = MealModel()
        if let text = nameTextField.text {
            meal.name = text
        }
        if let text = reViewTextView.text {
            meal.reviewContent = text
        }
        if let image = photoImageView.image {
            saveImage(image: image)
            meal.pathPhoto = path
        }
        meal.rating = ratingControl.rating
        meal.id = String.random()
        try! realm.write {
            realm.add(meal)
        }
        let number = realm.objects(MealModel.self).count
        if count == number - 1 {
            showAlertViewController(type: .notice, message: "Add new food success", close: {
                self.count += 1
            })
        }
    }
    
    func checkFood() -> Bool {
        if nameTextField.text == "" {
            showAlertViewController(type: .error, message: "Chưa nhập tên món ăn", close: {
                
            })
            return false
        }
        if reViewTextView.text == "" {
            showAlertViewController(type: .error, message: "Chưa có nhận xét", close: {
                
            })
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Chọn ảnh từ", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Máy ảnh", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Bộ sưu tập", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Hủy", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            //            alert.popoverPresentationController?.sourceView = sender
            //            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            //            isOpenCamera = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

}

extension NewMealViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolder.isHidden = !textView.text.isEmpty
    }
}

extension NewMealViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            photoImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            let random = String.random()
            
            path = "fl\(random).png"
            try data.write(to: directory.appendingPathComponent(path)!)
        } catch {
            print(error.localizedDescription)
        }
    }
}
