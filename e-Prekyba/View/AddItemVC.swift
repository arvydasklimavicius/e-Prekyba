//
//  AddItemVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-04.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    //MARK: - Variables
    var category: Category!
    var itemImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - Actions
    @IBAction func doneBtnTapped(_ sender: Any) {
        dismissKeyboard()
        
        if checkFieldsAreFilled() {
            saveItemToFirebase()
        } else {
            print("Error, show to user")
        }
    }
    @IBAction func cameraBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //MARK: -  Helper Functions
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func checkFieldsAreFilled() -> Bool {
        return (titleTxtField.text != "" && priceTxtField.text != "" && descriptionTxtView.text != "")
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Save item to Firebase
    private func saveItemToFirebase() {

        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTxtField.text!
        item.categoryId = category.id
        item.description = descriptionTxtView.text!
        item.price = Double(priceTxtField.text!)

        if itemImages.count > 0 {

        } else {
            saveItemToFirestore(item)
            popTheView()
        }

    }
}
