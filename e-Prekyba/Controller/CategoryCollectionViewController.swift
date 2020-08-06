//
//  CategoryCollectionViewController.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-07-30.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit


class CategoryCollectionViewController: UICollectionViewController {
    
    var categoryArray: [Category] = []
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 15.0, bottom: 20.0, right: 15.0)
    private let itemsPerRow: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
    }
  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        cell.configureCell(categoryArray[indexPath.row])
        return cell
    }
    
    //MARK: UICollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toCategoryItems", sender: categoryArray[indexPath.row])
    }
    
    //MARK: Download categories
    private func loadCategories() {
        
        downloadCategoriesFromFirebase { (allCategories) in
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Navigarion
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCategoryItems" {
            let vc = segue.destination as! ItemsTVC
            vc.category = sender as! Category
        }
    }
    
}

//MARK: Configure Collection View Layout

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
