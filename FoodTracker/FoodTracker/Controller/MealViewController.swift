//
//  ViewController.swift
//  FoodTracker
//
//  Created by Apple on 1/9/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MealViewController: BaseViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var meal = MealModel()
    let imagePicker =  UIImagePickerController()
    var path: String = ""
    var closureUpdate: ((MealModel) -> ())?
    var placeHolderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveMeal))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        imagePicker.delegate = self
        // Handle the text field's user input through delegte callback.
        nameTextField.delegate = self
        
        fillData()
        
        placeHolderLabel = UILabel()
        setPlaceholder(textView: reviewTextView, label: placeHolderLabel, text: "Nhận xét")
        reviewTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Detail Food"
    }
    
    func fillData() {
        nameTextField.text = meal.name
        //            photoImageView.image = loadImageFromPath(meal.pathPhoto as NSString)
        if let photo = getSavedImage(named: meal.pathPhoto) {
            photoImageView.image = photo
        }
        
        ratingControl.rating = meal.rating
        path = meal.pathPhoto
        reviewTextView.text = meal.reviewContent
    }
    
    @objc func saveMeal() {
        guard checkFood() else {
            return
        }
        showAlertWithConfirm(type: .notice, message: "Bạn chắc chắn muốn cập nhật thông tin đã chỉnh sửa", cancel: {
            
        }, ok: {
            let data = self.edit()
            self.closureUpdate?(data)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func edit() -> MealModel {
        let newMeal = MealModel()
        if let text = nameTextField.text {
            newMeal.name = text
        }
        if let text = reviewTextView.text {
            newMeal.reviewContent = text
        }
        if let image = photoImageView.image {
            saveImage(image: image)
            newMeal.pathPhoto = path
        }
        newMeal.id = meal.id
        newMeal.rating = ratingControl.rating
        return newMeal
    }
    
    func checkFood() -> Bool {
        if nameTextField.text == "" {
            showAlertViewController(type: .error, message: "Chưa nhập tên món ăn", close: {})
            return false
        }
        if reviewTextView.text == "" {
            showAlertViewController(type: .error, message: "Chưa nhận xét món ăn", close: {})
            return false
        }
        return true
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        //        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
            fatalError("Expected a dictionary containning an image, but was provided the follwing: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
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
        // Hie the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media their from photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user pick an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tapChooseImage(_ sender: UITapGestureRecognizer) {
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
    
    
}

extension MealViewController: UIImagePickerControllerDelegate {
    
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
    
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            photoImageView.image = pickedImage
            
            //            if saveImage(image: pickedImage) {
            //                collectionView.reloadData()
            //            }
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
            path = meal.pathPhoto
            try data.write(to: directory.appendingPathComponent(path)!)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension MealViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !(reviewTextView.text.isEmpty)
    }
}

