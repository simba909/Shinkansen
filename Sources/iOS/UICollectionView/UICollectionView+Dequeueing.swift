//
//  UICollectionView+Dequeueing.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

extension UICollectionView {
    public func dequeueReusableCell<Cell: UICollectionViewCell>(ofType cellType: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: ReusableView {
        let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)

        if let cell = cell as? Cell {
            return cell
        } else {
            fatalError("Failed to dequeue cell of type \(cellType)")
        }
    }
}
