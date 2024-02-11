//
//  MenuView+CollectionView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import Foundation
import UIKit

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func reloadColectionView() {
        DispatchQueue.main.async {
            self.menuCollection.reloadData()
        }

    }
    
    func setupCollectionView() {

        self.menuCollection.delegate = self
        self.menuCollection.dataSource = self
        self.menuCollection.showsVerticalScrollIndicator = false
        self.menuCollection.showsHorizontalScrollIndicator = false
        self.menuCollection.contentInset = UIEdgeInsets(top: 10.0, left: 9.0, bottom: 10.0, right: 9.0)
        
        registerCollectionCell()
    }
    
    func registerCollectionCell() {
        self.menuCollection.register(MenuItemCollectionViewCell.self, forCellWithReuseIdentifier: MenuItemCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter?.numberOfItemsInSection(in: section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.presenter?.numberOfSection() ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCollectionViewCell.identifier, for: indexPath) as! MenuItemCollectionViewCell
        if let item = presenter?.items[indexPath.row] {
            cell.delegate = self
            cell.configure(with: item)
        }
        return cell
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 205)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
