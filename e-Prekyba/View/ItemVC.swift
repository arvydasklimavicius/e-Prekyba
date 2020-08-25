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

        
    }
    
    
    

}
