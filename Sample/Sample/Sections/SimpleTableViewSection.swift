//
//  SimpleTableViewSection.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-02-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import UIKit
import Shinkansen

final class SimpleTableViewSection: NSObject, TableViewSection {
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
        tableView.register(SimpleTextTableViewCell.self)
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