//
//  Basket.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-27.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation

class Basket {
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[cOBJECTID] as? String
        ownerId = _dictionary[cOWNERID] as? String
        itemIds = _dictionary[cITEMSID] as? [String]
    }
    
}
//MARK: DOwnload basket from Firestore
func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?) -> ()) {
    FirebaseReferrence(.Basket).whereField(cOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(nil)
            return
        }
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}

//MARK: - Save Basket to Firestore

func saveCartToFirestore(_ basket: Basket) {
    FirebaseReferrence(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
}

//MARK: - Helper Functions

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
    return NSDictionary(objects: [basket.id, basket.itemIds, basket.ownerId], forKeys: [cOBJECTID as NSCopying, cITEMSID as NSCopying, cOWNERID as NSCopying])
}

//MARK: - Update Basket

func updateBasketInFirestore(_ basket: Basket,
                             withValues: [String: Any],
                             completion: @escaping (_ error: Error?) -> ()) {
    FirebaseReferrence(.Basket).document(basket.id).updateData(withValues) { (error) in
        completion(error)
    }
}
