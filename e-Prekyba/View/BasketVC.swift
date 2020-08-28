//
//  BasketVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-28.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit
import JGProgressHUD

class BasketVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var itemsInCartLbl: UILabel!
    @IBOutlet weak var totalSumLbl: UILabel!
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var checkoutBtn: UIButton!
    
    //MARK: - VAriables
    var basket: Basket? //optional because we don't know if user has basket
    var allItems: [Item] = []
    var itemsInCartIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutBtn.layer.cornerRadius = 8
        basketTableView.delegate = self
        basketTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: - check if user is logged in
        loadBasketFromFirestore()
    }
    
    //MARK: - Actions
    @IBAction func checkoutBtnTapped(_ sender: Any) {
    }
    
    //MARK: - Load Basket
    private func loadBasketFromFirestore() {
        downloadBasketFromFirestore("1234") { (basket) in
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems() {
        if basket != nil {
            downloadItemsByIds(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.basketTableView.reloadData()
            }
        }
    }
    
    //Helper Functions
    private func updateTotalLabels(_ isEmpty: Bool) {
        if isEmpty {
            itemsInCartLbl.text = "0"
            totalSumLbl.text = calculateTotalBasketSum()
        } else {
            itemsInCartLbl.text = "\(allItems.count)"
            totalSumLbl.text = calculateTotalBasketSum()
        }
        checkouBtnStatusUpdate()
    }
    
    private func calculateTotalBasketSum() -> String {
        var totalSum = 0.0
        
        for item in allItems {
            totalSum += item.price
        }
        return convertToCurrency(totalSum)
    }
    
    private func checkouBtnStatusUpdate() {
        checkoutBtn.isEnabled = allItems.count > 0
        
        if checkoutBtn.isEnabled {
            checkoutBtn.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        } else {
            checkoudBtnDisabled()
        }
    }
    private func checkoudBtnDisabled() {
        checkoutBtn.isEnabled = false
        checkoutBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }

}

extension BasketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ItemTVCell
        cell.configureItemCell(allItems[indexPath.row])
        return cell 
    }
    
    
}
