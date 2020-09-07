//
//  UserTableVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-05.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit


class UserTableVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var finishRegistrationBtnOutlet: UIButton!
    @IBOutlet weak var purchaseHistoryBtnOutlet: UIButton!
    
    //MARK: - VAriables
    var editButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() //removes empty cells from view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLoginStatus()
        checkOnboardingStatus()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    //MARK: - TableView delegates
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Helper functions
    private func createRightBarButtonItem(title: String) {
        editButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        editButtonOutlet.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem = editButtonOutlet
    }
    
    @objc func rightBarButtonItemTapped() {
        if editButtonItem.title == "Login" {
            showLoginView()
        } else {
            editProfileView()
        }
    }
    
    private func checkLoginStatus() {
        if User.currentUser() == nil {
            createRightBarButtonItem(title: "Login")
        } else {
            createRightBarButtonItem(title: "Edit")
        }
    }
    
    private func checkOnboardingStatus() {
        if User.currentUser() != nil {
            if User.currentUser()!.onBoard{
                finishRegistrationBtnOutlet.setTitle("Account is active!", for: .normal)
                finishRegistrationBtnOutlet.isEnabled = false
            } else {
                finishRegistrationBtnOutlet.setTitle("Finish registration!", for: .normal)
                finishRegistrationBtnOutlet.isEnabled = true
                finishRegistrationBtnOutlet.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) // need to change text color!
                
            }
        } else {
            finishRegistrationBtnOutlet.setTitle("Logged Out", for: .normal)
            finishRegistrationBtnOutlet.isEnabled = false
            purchaseHistoryBtnOutlet.isEnabled = false
        }
    }
    
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func editProfileView() {
        print("go to profile edit view")
    }
    

}
