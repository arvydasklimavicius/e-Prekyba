//
//  ItemVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-25.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemVC: UIViewController {
    
    //Otlets
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    //MARK: - Variables
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dovnloadPictures()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(self.backAction))]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.addToCartButtonPressed))]
        
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        if item != nil {
            self.title = item.name
            nameLbl.text = item.name
            priceLbl.text = convertToCurrency(item.price)
            descriptionTxtView.text = item.description
        }
    }
    
    //MARK: - Download Pictures
    private func dovnloadPictures() {
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imagesCollectionView.reloadData()
                }
            }
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToCartButtonPressed() {
        print("Add to cart", item.name)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

}

extension ItemVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count //jei gausim 0 pict mes rodom 1 paveiksliuka(placeholder)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImagesCell", for: indexPath) as! ImageCollectionViewCell
        if itemImages.count > 0 {
            cell.setupImageView(itemImage: itemImages[indexPath.row])
        }
        
        return cell
    }
    
    
}
