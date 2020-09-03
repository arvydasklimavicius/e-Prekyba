//
//  LoginVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-01.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class LoginVC: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var emailTxtLbl: UITextField!
    @IBOutlet weak var passwordTxtLbl: UITextField!
    @IBOutlet weak var resendemailBtnOulet: UIButton!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: correct activity indicator position, now is wrong
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.height / 2 - 30,
                                                                  y: self.view.frame.width / 2 - 30,
                                                                  width: 60.0,
                                                                  height: 60.0),
                                                    type: .ballGridPulse,
                                                    color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                                                    padding: nil)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        if fieldsHaveText() {
            loginUser()
        } else {
            emptyTextFieldError()
        }
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        if fieldsHaveText() {
            registerUser()
        } else {
           emptyTextFieldError()
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dissmisView()
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        
    }
    
    //MARK: - Login User
    private func loginUser() {
        showActivityIndicator()
        User.loginUserWith(emailTxtLbl.text!, passwordTxtLbl.text!) { (error, isEmailVerified) in
            if error == nil {
                if isEmailVerified {
                    self.dissmisView()
                } else {
                    self.hud.textLabel.text = "Please verify your email!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideActivityIndicator()
        }
    }
    
    //MARK: - Register User
    private func registerUser() {
        showActivityIndicator()
        User.registerUser(email: emailTxtLbl.text!, password: passwordTxtLbl.text!) { (error) in
            if error == nil {
                self.hud.textLabel.text = "Verification Email was sent!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.hideActivityIndicator()
        }
    }
    
    //MARK: - Helpers
    private func dissmisView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func fieldsHaveText()  -> Bool {
        return (emailTxtLbl.text != "" && passwordTxtLbl.text != "")
    }
    
    private func emptyTextFieldError() {
        hud.textLabel.text = "All fields are required"
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.0)
    }
    
    //MARK: - Activity Indicator
    private func showActivityIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
}
