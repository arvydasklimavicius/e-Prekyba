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
        finishRegistration() 
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
    
    private func finishRegistration() {
        let withValues = [cUSERNAME: nameTxtField.text!,
                          cLASTNAME: surnameTxtField.text!,
                          cFULLADDRESS: addressTxtField.text!,
                          cFULLNAME: (nameTxtField.text! + " " + surnameTxtField.text!),
                          cONBOARD: true,
                          
        ] as [String: Any]
        
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            if error == nil {
                self.hud.textLabel.text = "User information updated"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
}
