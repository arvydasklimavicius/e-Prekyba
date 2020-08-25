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
    
    

}

extension ItemVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
