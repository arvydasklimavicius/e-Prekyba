//
//  CategoryCollectionViewCell.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-07-30.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(_ category: Category) {
        nameLabel.text = category.name
        imageView.image = category.image
    }
    
    
    
    
    
    
}
