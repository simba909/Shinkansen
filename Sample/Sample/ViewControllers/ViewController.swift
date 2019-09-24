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

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        configureSections()
        shinkansen.view = tableView
    }

    private func configureSections() {
        let fruitsSection = shinkansen.createSection(
            from: ArrayBackedDataSource(items: ["Apple", "Banana"]),
            cellConfigurator: { tableView, fruit, indexPath in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = fruit

                return cell
        })

        fruitsSection.sectionHeader = "Fruits"
        fruitsSection.rowSelectionClosure = { [weak self] fruit, indexPath in
            let detailViewController = DetailViewController(title: fruit)
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
