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
    
    @IBOutlet weak var finidhRegistrationBtnOutlet: UIButton!
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

    //MARK: - Helper functions
    private func createRightBarButtonItem(title: String) {
        editButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
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
                finidhRegistrationBtnOutlet.setTitle("Account is active", for: .normal)
                finidhRegistrationBtnOutlet.isEnabled = false
            } else {
                finidhRegistrationBtnOutlet.setTitle("Finish registration!", for: .normal)
                finidhRegistrationBtnOutlet.tintColor = .red
                finidhRegistrationBtnOutlet.isEnabled = true
            }
        } else {
            finidhRegistrationBtnOutlet.setTitle("Logged Out", for: .normal)
            finidhRegistrationBtnOutlet.isEnabled = false
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
