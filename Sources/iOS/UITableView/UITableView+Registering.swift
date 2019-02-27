//
//  UITableView+Registering.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

extension UITableView {
    public func register<Cell: UITableViewCell>(_ cellType: Cell.Type) where Cell: ReusableView {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    public func register<Cell: UITableViewCell>(_ cellType: Cell.Type) where Cell: ReusableView & NibLoadableView {
        let bundle = Bundle(for: cellType)
        let nib = UINib(nibName: cellType.nibName, bundle: bundle)

        register(nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
}
