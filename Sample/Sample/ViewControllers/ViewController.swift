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

class ViewController: UITableViewController {
    private let shinkansen = TableViewShinkansen()
    private let communicator = AlamofireCommunicator()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sample"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        configureSections()
        shinkansen.view = tableView
    }

    private func configureSections() {
        let channelRepository = ChannelRepository(communicator: communicator)
        let channelDataSource = RepositoryDataSource(repository: channelRepository)
        let channelSection = shinkansen.createSection(from: channelDataSource) { tableView, channel, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = channel.name

            return cell
        }

        channelSection.sectionHeader = "Channels"

        let fruitsDataSource = ArrayBackedDataSource(items: ["Apple", "Banana"])
        let fruitsSection = shinkansen.createSection(from: fruitsDataSource) { tableView, fruit, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = fruit

            return cell
        }
        fruitsSection.sectionHeader = "Fruits"
        fruitsSection.rowSelectionClosure = { [weak self] fruit in
            let detailViewController = DetailViewController(title: fruit)
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }

        let repository = PlayingNowRepository(communicator: communicator)
        let nowPlayingDataSource = PlayingNowDataSource(repository: repository)
        let nowPlayingSection = shinkansen.createSection(from: nowPlayingDataSource) { tableView, item, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = item.currently?.title ?? "Nothing playing"

            return cell
        }
        nowPlayingSection.sectionHeader = "Now playing"
    }
}
