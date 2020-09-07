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
    private func checkForFilledFields() {
        nameTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_ : )), for: UIControl.Event.editingChanged)
        surnameTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_ : )), for: UIControl.Event.editingChanged)
        addressTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_ : )), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateDoneButtonStatus()
    }
    
    //MARK: - Helper functions
    private func updateDoneButtonStatus() {
        if nameTxtField.text != "" && surnameTxtField.text != "" && addressTxtField.text != "" {
            doneBtnOutlet.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            doneBtnOutlet.isEnabled = true
        } else {
            doneBtnOutlet.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            doneBtnOutlet.isEnabled = false
        }
        
    }
    
}
