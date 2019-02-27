//
//  CollectionViewSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public protocol CollectionViewSection: Section, UICollectionViewDataSource {
    func registerCell(in collectionView: UICollectionView)
}
