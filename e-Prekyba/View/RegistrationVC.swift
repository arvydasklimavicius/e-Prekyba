//
//  RegistrationVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-07.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import JGProgressHUD

class RegistrationVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var doneBtnOutlet: RoundedButton!
    
    //MARK: - VAriables
    let hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForFilledFields()

        
    }
    
    //MARK: - Actions
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - text fields actions
    func checkForFilledFields() {
        nameTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_ : )), for: UIControl.Event.editingChanged)
        surnameTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_ : )), for: UIControl.Event.editingChanged)
        addressTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_ : )), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
    
}
