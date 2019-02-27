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

    private weak var conductor: SectionConductor?

    var cellRegistrationClosure: ((UITableView) -> Void)?

    public var sectionHeader: String? {
        didSet {
            conductor?.reloadSection(self)
        }
    }

    public init(dataSource: DataSource, cellConfigurator: @escaping ((UITableView, IndexPath) -> UITableViewCell)) {
        self.dataSource = dataSource
        self.cellConfigurator = cellConfigurator

        super.init()
    }

    public func setConductor(_ conductor: SectionConductor) {
        self.conductor = conductor
        dataSource.setConductor(conductor)
    }

    public func registerCell(in tableView: UITableView) {
        cellRegistrationClosure?(tableView)
    }

    // MARK: - UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.itemCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellConfigurator(tableView, indexPath)
        return cell
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader
    }
}
