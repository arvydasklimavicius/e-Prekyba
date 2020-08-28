//
//  Item.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-04.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation
import UIKit

class Item {
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[cOBJECTID] as? String
        categoryId = _dictionary[cCATEGORYID] as? String
        name = _dictionary[cNAME] as? String
        description = _dictionary[cDESCRIPTION] as? String
        price = _dictionary[cPRICE] as? Double
        imageLinks = _dictionary[cIMAGELINKS] as? [String]
    }
}

//MARK: Save Items to Firebase

func saveItemToFirestore (_ item: Item) {
     
    FirebaseReferrence(.Item).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}

//MARK: Item from Firebase
func itemDictionaryFrom(_ item: Item) -> NSDictionary{
    return NSDictionary(objects: [
        item.id,
        item.categoryId,
        item.name,
        item.description,
        item.price,
        item.imageLinks],
                        forKeys: [
                            cOBJECTID as NSCopying,
    cCATEGORYID as NSCopying,
    cNAME as NSCopying,
    cDESCRIPTION as NSCopying,
    cPRICE as NSCopying,
    cIMAGELINKS as NSCopying])
}


//MARK: - Download Item from firebase
func downloadItem(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> ()) {
    var itemArray: [Item] = []
    FirebaseReferrence(.Item).whereField(cCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        if !snapshot.isEmpty {
            for itemDictionary in snapshot.documents {
                itemArray.append(Item(_dictionary: itemDictionary.data() as NSDictionary))
            }
        }
        completion(itemArray)
    }
    
}

//MARK: - Download Items By ID's
func downloadItemsByIds(_ withIds: [String], completioin: @escaping (_ itemArray: [Item]) -> ()) {
    var count = 0
    var itemArray: [Item] = []
    
    if withIds.count > 0 {
        for itemId in withIds {
            FirebaseReferrence(.Item).document(itemId).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    completioin(itemArray)
                    return
                }
                if snapshot.exists {
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                if count == withIds.count {
                    completioin(itemArray)
                }
            }
        }
    } else {
        completioin(itemArray)
    }
}
