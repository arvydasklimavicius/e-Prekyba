//
//  FirebaseCollectionRefference.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-07-30.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReferrence: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReferrence(_ collectionReferrence: FCollectionReferrence) -> CollectionReference {
    return Firestore.firestore().collection(collectionReferrence.rawValue)
}
