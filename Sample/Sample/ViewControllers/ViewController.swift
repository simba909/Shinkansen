//
//  ViewController.swift
//  Shinkansen Sample
//
//  Created by Simon Jarbrant on 2019-01-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import UIKit
import Shinkansen
import DangoKit

extension UITableViewCell: ReusableView {}

class ViewController: UITableViewController {
    private let shinkansen = TableViewShinkansen()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sample"

        shinkansen.view = tableView

        let section = SimpleTableViewSection(values: ["Meh!", "Baaah..."])
        shinkansen.connectSection(section)

        let peopleDataSource = ArrayBackedDataSource(items: ["Simon", "Minami"])
        let peopleSection = shinkansen.createSection(from: peopleDataSource, withCellType: UITableViewCell.self, cellConfigurator: { item, cell in
            cell.textLabel?.text = item
            return cell
        })
        peopleSection.sectionHeader = "People"

        let fruitsDataSource = ArrayBackedDataSource(items: ["Apple", "Banana"])
        let fruitsSection = shinkansen.createSection(from: fruitsDataSource, withCellType: UITableViewCell.self, cellConfigurator: { item, cell in
            cell.textLabel?.text = item
            return cell
        })
        fruitsSection.sectionHeader = "Fruits"
        fruitsSection.rowSelectionClosure = { [weak self] fruit in
            let detailViewController = DetailViewController(title: fruit)
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }

        let communicator = AlamofireCommunicator()
        let repository = PlayingNowRepository(communicator: communicator)
        let nowPlayingDataSource = PlayingNowDataSource(repository: repository)
        let nowPlayingSection = shinkansen.createSection(from: nowPlayingDataSource, withCellType: UITableViewCell.self) { item, cell in
            cell.textLabel?.text = item.currently?.title ?? "Nothing playing"
            return cell
        }
        nowPlayingSection.sectionHeader = "Now playing"
    }
}
