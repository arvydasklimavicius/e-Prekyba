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
}
