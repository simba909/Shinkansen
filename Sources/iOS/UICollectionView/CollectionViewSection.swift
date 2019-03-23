//
//  CollectionViewSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public protocol CollectionViewSection: Section, UICollectionViewDataSource {
    func registerCells(in collectionView: UICollectionView)
    func sizeForHeader() -> CGSize
    func sizeForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize
}

public extension CollectionViewSection {
    static var defaultItemSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 56.0)
    }

    func sizeForHeader() -> CGSize {
        return .zero
    }

    func sizeForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        return Self.defaultItemSize
    }
}
