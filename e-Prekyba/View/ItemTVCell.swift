//
//  ItemTVCell.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-20.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit

class ItemTVCell: UITableViewCell {
    
    //Otlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureItemCell(_ item: Item) {
        titleLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertToCurrency(item.price)
        
        //Checking for images to download
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            downloadImages(imageUrls: [item.imageLinks.first!]) { (images) in
                self.productImageView.image = images.first as? UIImage
            }
        }
    }

}
