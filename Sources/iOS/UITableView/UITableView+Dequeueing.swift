//
//  UITableView+Dequeueing.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(ofType type: Cell.Type, at indexPath: IndexPath) -> Cell where Cell: ReusableView {
        let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath)

        if let cell = cell as? Cell {
            return cell
        } else {
            fatalError("Failed to dequeue cell of type \(type)")
        }
    }
}
