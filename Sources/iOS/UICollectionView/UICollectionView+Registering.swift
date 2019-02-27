//
//  UICollectionView+Registering.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

extension UICollectionView {
    public func register<Cell: UICollectionViewCell>(_ cellType: Cell.Type) where Cell: ReusableView {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    public func register<Cell: UICollectionViewCell>(_ cellType: Cell.Type) where Cell: ReusableView & NibLoadableView {
        let bundle = Bundle(for: cellType)
        let nib = UINib(nibName: cellType.nibName, bundle: bundle)

        register(nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
}
