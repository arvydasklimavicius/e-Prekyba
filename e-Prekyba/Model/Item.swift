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
