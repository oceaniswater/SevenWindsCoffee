//
//  CoffeeShopsView+TableView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CoffeeShopsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.registerTableCell()
    }
    
    func registerTableCell() {
        tableView.register(CoffeeShopTableViewCell.self, forCellReuseIdentifier: CoffeeShopTableViewCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoffeeShopTableViewCell.identifier, for: indexPath) as? CoffeeShopTableViewCell else { return UITableViewCell() }

        guard let shop = self.presenter?.shops[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: shop)
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let shopId = presenter?.shops[indexPath.row].id else { return }
        presenter?.tapOnItem(id: shopId)
    }
    
    
}
