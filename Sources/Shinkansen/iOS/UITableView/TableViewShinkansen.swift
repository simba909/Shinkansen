//
//  TableViewShinkansen.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public class TableViewShinkansen: NSObject, Shinkansen {
    public private(set) var sections: [TableViewSection] = []

    public weak var view: UITableView? {
        didSet {
            guard let view = view else { return }
            view.dataSource = self
            view.delegate = self
        }
    }

    public func connectSection(_ section: TableViewSection) {
        section.setConductor(self)

        guard let tableView = view else {
            sections.append(section)
            return
        }

        tableView.performBatchUpdates({
            let sectionIndex = sections.count
            sections.append(section)
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        })
    }

    @discardableResult
    public func createSection<DataSource: SectionDataSource>(
        from dataSource: DataSource,
        cellConfigurator: @escaping TableViewDataSourceSection<DataSource>.CellConfigurator) -> TableViewDataSourceSection<DataSource> {

        let section = TableViewDataSourceSection(dataSource: dataSource, cellConfigurator: cellConfigurator)
        connectSection(section)

        return section
    }
}

// MARK: - UITableViewDataSource
extension TableViewShinkansen: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tableView(tableView, numberOfRowsInSection: 0)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        return section.tableView(tableView, cellForRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.tableView?(tableView, titleForHeaderInSection: 0)
    }
}

// MARK: - UITableViewDelegate
extension TableViewShinkansen: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        section.tableView?(tableView, didSelectRowAt: localIndexPath)
    }
}

// MARK: - SectionConductor
extension TableViewShinkansen: SectionConductor {
    public func reloadSection(_ section: ShinkansenSection) {
        guard let tableView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let sectionIndices = IndexSet([sectionIndex])
        tableView.reloadSections(sectionIndices, with: .automatic)
    }

    public func reloadItems(at indices: [Int], for section: ShinkansenSection, dataSourceUpdateClosure: () -> Void) {
        guard !indices.isEmpty else {
            return
        }

        guard let tableView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let reloadIndexPaths = indices.map { IndexPath(row: $0, section: sectionIndex) }

        tableView.performBatchUpdates({
            // Allow the data source to update
            dataSourceUpdateClosure()

            // Perform UITableView updates
            tableView.reloadRows(at: reloadIndexPaths, with: .automatic)
        })
    }

    public func performChanges(_ changes: ChangeSet, for section: ShinkansenSection, dataSourceUpdateClosure: () -> Void) {
        guard let tableView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let insertIndexPaths = changes.insertions.map { IndexPath(row: $0, section: sectionIndex) }
        let deletionIndexPaths = changes.deletions.map { IndexPath(row: $0, section: sectionIndex) }
        let moveIndexPaths = changes.moves.map { move -> (origin: IndexPath, destination: IndexPath) in
            return (IndexPath(row: move.from, section: sectionIndex), IndexPath(row: move.to, section: sectionIndex))
        }

        tableView.performBatchUpdates({
            // Allow the data source to update
            dataSourceUpdateClosure()

            // Perform UITableView updates
            tableView.deleteRows(at: deletionIndexPaths, with: .automatic)
            tableView.insertRows(at: insertIndexPaths, with: .automatic)

            for move in moveIndexPaths {
                tableView.moveRow(at: move.origin, to: move.destination)
            }
        })
    }
}
