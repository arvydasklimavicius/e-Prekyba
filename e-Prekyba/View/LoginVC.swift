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
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.height / 2 - 30,
                                                                  y: self.view.frame.width / 2 - 30,
                                                                  width: 60.0,
                                                                  height: 60.0),
                                                    type: .circleStrokeSpin,
                                                    color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                                                    padding: nil)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dissmisView()
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        
    }
    
    //MARK: - Helpers
    private func dissmisView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkForNotEmptyFields()  -> Bool {
        return (emailTxtLbl.text != "" && passwordTxtLbl.text != "")
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
