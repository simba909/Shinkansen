//
//  TableViewSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public protocol TableViewSection: Section, UITableViewDataSource, UITableViewDelegate {
    func registerCells(in tableView: UITableView)
}
