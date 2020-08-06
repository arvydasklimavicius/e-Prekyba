//
//  CategoryModel.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-07-30.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation
import UIKit


class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String) {
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[cOBJECTID] as! String
        name = _dictionary[cNAME] as! String
        image = UIImage(named: _dictionary[cIMAGENAME] as? String ?? "")
    }
}

//MARK: Download Category

func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FirebaseReferrence(.Category).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
        }
        
        completion(categoryArray)
    }
}

//MARK: Save Category Function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReferrence(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [cOBJECTID as NSCopying, cNAME as NSCopying, cIMAGENAME as NSCopying])
}
