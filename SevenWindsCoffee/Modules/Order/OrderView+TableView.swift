//
//  OrderView+TableView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource
extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.registerTableCell()
    }
    
    func registerTableCell() {
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as? OrderTableViewCell else { return UITableViewCell() }
        
        guard let item = self.presenter?.items[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: item)
        cell.selectionStyle = .none
        
        return cell
        
    }
}
