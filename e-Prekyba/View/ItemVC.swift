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
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.addToCartButtonPressed))]
        
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
        if User.currentUser() != nil {
            downloadBasketFromFirestore(User.currentId()) { (basket) in
                if basket == nil {
                    self.createNewBasket()
                } else {
                    basket!.itemIds.append(self.item.id)
                    self.updateBasket(basket: basket!, vithValues: [cITEMSID : basket!.itemIds])
                }
            }
        } else {
            showLoginView()
        }
        
        
    }
    
    //MARK: - Add to basket func
    private func createNewBasket() {
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = User.currentId()
        newBasket.itemIds = [self.item.id]
        saveCartToFirestore(newBasket)
        
        self.hud.textLabel.text = "Added to cart"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateBasket(basket: Basket, vithValues: [String: Any]) {
        updateBasketInFirestore(basket, withValues: vithValues) { (error) in
            if error != nil {
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                print(error!.localizedDescription)
            } else {
                self.hud.textLabel.text = "Added to cart"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    private func showLoginView() {
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
        
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
