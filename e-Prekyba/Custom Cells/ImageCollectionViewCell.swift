//
//  ImageCollectionViewCell.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-25.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageView(itemImage: UIImage) {
        imageView.image = itemImage
    }
    
}
