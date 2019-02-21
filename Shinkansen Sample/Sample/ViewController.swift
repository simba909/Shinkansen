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

        shinkansen.view = tableView

        let section = SimpleSection(values: ["Meh!", "Baaah..."])
        shinkansen.connectSection(section)

        let peopleDataSource = SimpleDataSource(values: ["Simon", "Minami"])
        shinkansen.createSection(from: peopleDataSource, withCellType: SimpleTextTableViewCell.self, cellConfigurator: { item, cell in
            cell.setText(item)
            return cell
        })

        let fruitsDataSource = SimpleDataSource(values: ["Apple", "Banana"])
        shinkansen.createSection(from: fruitsDataSource, withCellType: SimpleTextTableViewCell.self, cellConfigurator: { item, cell in
            cell.setText(item)
            return cell
        })
    }
}

struct SimpleDataSource: SectionDataSource {
    let values: [String]

    var itemCount: Int {
        return values.count
    }

    func setConductor(_ conductor: SectionConductor) {
        // Unused
    }

    func getItem(at index: Int) -> String {
        return values[index]
    }
}

class SimpleSection: NSObject, TableViewSection {
    let id: Int = 0

    private let values: [String]

    private weak var conductor: SectionConductor?

    init(values: [String]) {
        self.values = values
        super.init()
    }

    func setConductor(_ conductor: SectionConductor) {
        self.conductor = conductor
    }

    func registerCell(in tableView: UITableView) {
        tableView.register(cellType: SimpleTextTableViewCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: SimpleTextTableViewCell.self, at: indexPath)

        let value = values[indexPath.row]
        cell.setText(value)
        return cell
    }
}
