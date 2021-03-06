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
    
    //MARK: - Variables
    var basket: Basket? //optional because we don't know if user has basket
    var allItems: [Item] = []
    var itemsInCartIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    var environment: String = PayPalEnvironmentNoNetwork {
        willSet (newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalconfig = PayPalConfiguration()
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPayPal()
        basketTableView.delegate = self
        basketTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if User.currentUser() != nil {
            loadBasketFromFirestore()
        } else {
            self.updateTotalLabels(true)
        }
        
    }
    
    //MARK: - Actions
    @IBAction func checkoutBtnTapped(_ sender: Any) {
        if User.currentUser()!.onBoard {
            //proceed with purchase
            payButtonTapped()
        } else {
            self.hud.textLabel.text = "Please enter full profile informaation"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    //MARK: - Load Basket
    private func loadBasketFromFirestore() {
        downloadBasketFromFirestore(User.currentId()) { (basket) in
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
    
    private func emptyBasket() {
        itemsInCartIds.removeAll()
        allItems.removeAll()
        basket!.itemIds = []
        
        updateBasketInFirestore(basket!, withValues: [cITEMSID : basket!.itemIds]) { (error) in
            if error != nil {
                print("Error updating basket ", error!.localizedDescription)
            }
            self.getBasketItems()
        }
    }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]) {
        if User.currentUser() != nil {
            let newItemIds = User.currentUser()!.purchasedItemIds + itemIds
            updateCurrentUserInFirestore(withValues: [cPURCHASEDITEMIDS : newItemIds]) { (error) in
                if error != nil {
                    print("Error adding purchased items ", error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Navigation
    private func showItemView (withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil ).instantiateViewController(identifier: "itemView") as! ItemVC
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: - Checkout button configuration and helper functions
    private func checkouBtnStatusUpdate() {
        checkoutBtn.isEnabled = allItems.count > 0
        
        if checkoutBtn.isEnabled {
            checkoutBtn.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            checkoudBtnDisabled()
        }
    }
    private func checkoudBtnDisabled() {
        checkoutBtn.isEnabled = false
        checkoutBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        checkoutBtn.titleLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    //Removing item from firestore basket
    private func removeItemFormBasket(itemId: String) {
        for item in 0..<basket!.itemIds.count {
            if itemId == basket!.itemIds[item] {
                basket!.itemIds.remove(at: item)
                return
            }
        }
    }
    
    //MARK: - Paypal Setup
    private func setupPayPal() {
        payPalconfig.acceptCreditCards = false
        payPalconfig.merchantName = "e - Prekyba"
        payPalconfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/lt/webapps/mpp/ua/privacy-full")
        payPalconfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/lt/webapps/mpp/ua/useragreement-full")
        payPalconfig.languageOrLocale = Locale.preferredLanguages[0] //device language
        payPalconfig.payPalShippingAddressOption = .both
    }
    
    private func payButtonTapped() {
        var itemsToBuy: [PayPalItem] = []
        
        for item in allItems {
            let tempItem = PayPalItem(name: item.name, withQuantity: 1, withPrice: NSDecimalNumber(value: item.price), withCurrency: "EUR", withSku: nil)
            itemsInCartIds.append(item.id)
            itemsToBuy.append(tempItem)
        }
        let subTotal = PayPalItem.totalPrice(forItems: itemsToBuy)
        
        //optional figures
        let tax = NSDecimalNumber(string: "2.00")
        let shippingCost = NSDecimalNumber(string: "5.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subTotal, withShipping: shippingCost, withTax: tax)
        let total = subTotal.adding(shippingCost).adding(tax)
        let payment = PayPalPayment(amount: total, currencyCode: "EUR", shortDescription: "Congrats!", intent: .sale)
        payment.items = itemsToBuy
        payment.paymentDetails = paymentDetails
        
        if payment.processable {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalconfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        } else {
            print("Payment not processable")
        }
        
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
    
    //MARK: - Deleting row (Edit TableView)
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFormBasket(itemId: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withValues: [cITEMSID : basket!.itemIds]) { (error) in
                if error != nil {
                    print("Error:", error?.localizedDescription)
                }
                self.getBasketItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
    
    
}

extension BasketVC: PayPalPaymentDelegate {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        paymentViewController.dismiss(animated: true) {
            self.addItemsToPurchaseHistory(self.itemsInCartIds)
            self.emptyBasket()
        }
    }
    
    
}
