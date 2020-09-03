//
//  User.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-03.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    let objectId: String
    var email: String
    var userName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    
    var fullAddress: String?
    var onBoard: Bool
    
    init(_objectId: String, _email: String, _userName: String, _lastName: String) {
        objectId = _objectId
        email = _email
        userName = _userName
        lastName = _lastName
        fullName = _userName + " " + _lastName
        purchasedItemIds = []
        fullAddress = ""
        onBoard = false
    }
    
    //MARK: - User Object init
    init(_dictioinary: NSDictionary) {
        objectId = _dictioinary[cOBJECTID] as! String
        
        if let mail = _dictioinary[cEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fname = _dictioinary[cUSERNAME] {
            userName = fname as! String
        } else {
            userName = ""
        }
        
        if let lname = _dictioinary[cLASTNAME] {
            lastName = lname as! String
        } else {
            lastName = ""
        }
        
        fullName = userName + " " + lastName
        
        if let faddress = _dictioinary[cFULLADDRESS] {
            fullAddress = faddress as! String
        } else {
            fullAddress = ""
        }
        
        if let onB = _dictioinary[cONBOARD] {
            onBoard = onB as! Bool
        } else {
            onBoard = false
        }
        
        if let purchaseIds = _dictioinary[cPURCHASEDITEMIDS] {
            purchasedItemIds = purchaseIds as! [String]
        } else {
            purchasedItemIds = []
        }
        
        
    }
    //MARK: - Return Current User
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    class func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            //checking that current user is the same as in saved userDefaults
            if let dictionary = UserDefaults.standard.object(forKey: cCURRENTUSER) {
                return User.init(_dictioinary: dictionary as!NSDictionary)
            }
        }
        return nil //User is Optional so we can have empty obj.
    }
}
