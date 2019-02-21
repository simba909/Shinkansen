//
//  TableViewDataSourceSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public class TableViewDataSourceSection<DataSource>: NSObject, TableViewSection where DataSource: SectionDataSource {
    public let id: Int = 0

    private let dataSource: DataSource
    private let cellConfigurator: (UITableView, IndexPath) -> UITableViewCell

    var cellRegistrationClosure: ((UITableView) -> Void)?

    public init(dataSource: DataSource, cellConfigurator: @escaping ((UITableView, IndexPath) -> UITableViewCell)) {
        self.dataSource = dataSource
        self.cellConfigurator = cellConfigurator

        super.init()
    }

    public func setConductor(_ conductor: SectionConductor) {
        dataSource.setConductor(conductor)
    }

    public func registerCell(in tableView: UITableView) {
        cellRegistrationClosure?(tableView)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.itemCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellConfigurator(tableView, indexPath)
        return cell
    }
}
