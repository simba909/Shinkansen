//
//  UITableView+Registering.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public extension UITableView {
    func register<Cell: UITableViewCell>(cellType type: Cell.Type) where Cell: ReusableView {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }

    func register<Cell: UITableViewCell>(cellType type: Cell.Type) where Cell: ReusableView & NibLoadableView {
        let bundle = Bundle(for: type)
        let nib = UINib(nibName: type.nibName, bundle: bundle)

        register(nib, forCellReuseIdentifier: type.reuseIdentifier)
    }
}
