//
//  EditProfileVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-07.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()

        
    }
    
    //MARK: - Actions
    @IBAction func saveBtnTapped(_ sender: Any) {
        dismissKeyboard()
        if textFieldsHaveText() {
            let withValues = [cUSERNAME: nameTxtField.text!,
                              cLASTNAME: surnameTxtField.text!,
                              cFULLNAME: (nameTxtField.text! + " " + surnameTxtField.text!),
                              cFULLADDRESS: addressTxtField.text!
            ]
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                if error == nil {
                    self.hud.textLabel.text = "User Info Updated!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                } else {
                    print("Error saving user ", error!.localizedDescription)
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        
    }
    
    //MARK: - Load user data to UI
    private func loadUserInfo() {
        if User.currentUser() != nil {
            let currentUser = User.currentUser()!
            nameTxtField.text = currentUser.userName
            surnameTxtField.text = currentUser.lastName
            addressTxtField.text = currentUser.fullAddress
        }
    }
    
    //MARK: - Helpers
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func textFieldsHaveText() -> Bool {
        return(nameTxtField.text != "" && surnameTxtField.text != "" && addressTxtField.text != "")
    }
}
