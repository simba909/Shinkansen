//
//  TableViewDataSourceSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public final class TableViewDataSourceSection<DataSource>: NSObject, TableViewSection where DataSource: SectionDataSource {
    public typealias CellConfigurator = (UITableView, DataSource.Item, IndexPath) -> UITableViewCell

    private let dataSource: DataSource
    private let cellConfigurator: CellConfigurator

    private weak var conductor: SectionConductor?

    public var rowSelectionClosure: ((DataSource.Item, IndexPath) -> Void)?

    public var sectionHeader: String? {
        didSet {
            conductor?.reloadSection(self)
        }
    }

    public init(dataSource: DataSource, cellConfigurator: @escaping CellConfigurator) {
        self.dataSource = dataSource
        self.cellConfigurator = cellConfigurator

        super.init()
    }

    public func setConductor(_ conductor: SectionConductor) {
        self.conductor = conductor
        dataSource.setConductor(self)
    }

    // MARK: UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource.items[indexPath.row]
        return cellConfigurator(tableView, item, indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader
    }

    // MARK: UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.items[indexPath.row]
        rowSelectionClosure?(item, indexPath)
    }
}

// MARK: - DataSourceConductor
extension TableViewDataSourceSection: DataSourceConductor {
    public func reloadItems(at indices: [Int], updateClosure: @escaping UpdateClosure) {
        conductor?.reloadItems(at: indices, for: self, dataSourceUpdateClosure: updateClosure)
    }

    public func performChanges(_ changes: ChangeSet, updateClosure: @escaping UpdateClosure) {
        conductor?.performChanges(changes, for: self, dataSourceUpdateClosure: updateClosure)
    }
}
