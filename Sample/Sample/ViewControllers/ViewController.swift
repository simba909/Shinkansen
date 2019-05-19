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
    private let communicator = AlamofireCommunicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sample"

        configureSections()
        shinkansen.view = tableView
    }

    private func configureSections() {
        let channelRepository = ChannelRepository(communicator: communicator)
        let channelDataSource = RepositoryDataSource(repository: channelRepository)
        let channelSection = shinkansen.createSection(from: channelDataSource, withCellType: UITableViewCell.self) { channel, cell in
            cell.textLabel?.text = channel.name
        }

        channelSection.sectionHeader = "Channels"

        let fruitsDataSource = ArrayBackedDataSource(items: ["Apple", "Banana"])
        let fruitsSection = shinkansen.createSection(from: fruitsDataSource, withCellType: UITableViewCell.self, cellConfigurator: { item, cell in
            cell.textLabel?.text = item
        })
        fruitsSection.sectionHeader = "Fruits"
        fruitsSection.rowSelectionClosure = { [weak self] fruit in
            let detailViewController = DetailViewController(title: fruit)
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }

        let repository = PlayingNowRepository(communicator: communicator)
        let nowPlayingDataSource = PlayingNowDataSource(repository: repository)
        let nowPlayingSection = shinkansen.createSection(from: nowPlayingDataSource, withCellType: UITableViewCell.self) { item, cell in
            cell.textLabel?.text = item.currently?.title ?? "Nothing playing"
        }
        nowPlayingSection.sectionHeader = "Now playing"
    }
}
