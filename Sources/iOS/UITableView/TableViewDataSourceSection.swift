//
//  TableViewDataSourceSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public final class TableViewDataSourceSection<DataSource>: NSObject, TableViewSection where DataSource: SectionDataSource {
    public typealias CellConfigurator = (UITableView, IndexPath, DataSource.Item) -> UITableViewCell
    public typealias CellRegistrator = (UITableView) -> Void

    private let dataSource: DataSource
    private let cellConfigurator: CellConfigurator
    private let cellRegistrator: CellRegistrator

    private weak var conductor: SectionConductor?

    public var rowSelectionClosure: ((DataSource.Item) -> Void)?

    public var sectionHeader: String? {
        didSet {
            conductor?.reloadSection(self)
        }
    }

    public init(dataSource: DataSource, cellConfigurator: @escaping CellConfigurator, cellRegistrator: @escaping CellRegistrator) {
        self.dataSource = dataSource
        self.cellConfigurator = cellConfigurator
        self.cellRegistrator = cellRegistrator

        super.init()
    }

    public func setConductor(_ conductor: SectionConductor) {
        self.conductor = conductor
        dataSource.setConductor(self)
    }

    public func registerCell(in tableView: UITableView) {
        cellRegistrator(tableView)
    }

    // MARK: - UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource.items[indexPath.row]
        return cellConfigurator(tableView, indexPath, item)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.items[indexPath.row]
        rowSelectionClosure?(item)
    }
}

// MARK: - DataSourceConductor
extension TableViewDataSourceSection: DataSourceConductor {
    public func reloadItems(at indices: [Int], updateClosure: () -> Void) {
        conductor?.reloadItems(at: indices, for: self, dataSourceUpdateClosure: updateClosure)
    }

    public func performChanges(_ changes: ChangeSet, updateClosure: () -> Void) {
        conductor?.performChanges(changes, for: self, dataSourceUpdateClosure: updateClosure)
    }
}
