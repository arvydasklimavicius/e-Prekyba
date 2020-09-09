//
//  ItemsTVC.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-04.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import UIKit

class ItemsTVC: UITableViewController {
    
    var category: Category?
    var itemArray: [Item] = []

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() //removes empty cells from view
        self.title = category?.name
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ItemTVCell
        cell.configureItemCell(itemArray[indexPath.row])
        return cell
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }

    
     //MARK: - Navigation

     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromItemToAddItem" {
            let vc = segue.destination as! AddItemVC
            vc.category = category!
        }
    }
    
    private func showItemView(_ item: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemVC
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    private func loadItems() {
        downloadItem(category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }


}
