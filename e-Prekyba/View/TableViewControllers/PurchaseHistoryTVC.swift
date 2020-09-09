//
//  PurchaseHistoryTVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-09.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit

class PurchaseHistoryTVC: UITableViewController {
    
    //MARK: - Variables
    var purhasedItemsArray: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return purhasedItemsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ItemTVCell
        cell.configureItemCell(purhasedItemsArray[indexPath.row])
        return cell
    }
    
    //MARK: - Load Items
    private func loadItems() {
        downloadItemsByIds(User.currentUser()!.purchasedItemIds) { (allItems) in
            self.purhasedItemsArray = allItems
            print("we have \(allItems.count) items purchased")
            self.tableView.reloadData()
        }
    }
    


}
