//
//  ViewController.swift
//  Shinkansen Sample
//
//  Created by Simon Jarbrant on 2019-01-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import UIKit
import Shinkansen

class ViewController: UITableViewController {
    private let shinkansen = TableViewShinkansen()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sample"

        shinkansen.view = tableView

        let section = SimpleTableViewSection(values: ["Meh!", "Baaah..."])
        shinkansen.connectSection(section)

        let peopleDataSource = ArrayBackedDataSource(items: ["Simon", "Minami"])
        let peopleSection = shinkansen.createSection(from: peopleDataSource, withCellType: SimpleTextTableViewCell.self, cellConfigurator: { item, cell in
            cell.setText(item)
            return cell
        })
        peopleSection.sectionHeader = "People"

        let fruitsDataSource = ArrayBackedDataSource(items: ["Apple", "Banana"])
        let fruitsSection = shinkansen.createSection(from: fruitsDataSource, withCellType: SimpleTextTableViewCell.self, cellConfigurator: { item, cell in
            cell.setText(item)
            return cell
        })
        fruitsSection.sectionHeader = "Fruits"
        fruitsSection.rowSelectionClosure = { [weak self] fruit in
            let detailViewController = DetailViewController(title: fruit)
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
