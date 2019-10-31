//
//  UITableView+ShinkansenView.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-06-08.
//

import UIKit

extension UITableView: ShinkansenView {

    public typealias CellType = UITableViewCell

    public func reloadSection(at index: Int) {
        let indexSet = IndexSet([index])
        reloadSections(indexSet, with: .automatic)
    }

    public func reloadItems(at indices: IndexSet, inSection section: Int, dataSourceUpdateClosure: () -> Void) {
        guard !indices.isEmpty else { return }

        performBatchUpdates({
            // Allow the data source to update
            dataSourceUpdateClosure()

            // Perform UITableView updates
            let reloadIndexPaths = indices.map { IndexPath(row: $0, section: section) }
            reloadRows(at: reloadIndexPaths, with: .automatic)
        })
    }

    public func applyChanges(_ changes: ChangeSet, inSection section: Int, dataSourceUpdateClosure: () -> Void) {
        let insertIndexPaths = changes.insertions.map { IndexPath(row: $0, section: section) }
        let deletionIndexPaths = changes.deletions.map { IndexPath(row: $0, section: section) }
        let moveIndexPaths = changes.moves.map { move -> (origin: IndexPath, destination: IndexPath) in
            return (
                origin: IndexPath(row: move.from, section: section),
                destination: IndexPath(row: move.to, section: section)
            )
        }

        performBatchUpdates({
            // Allow the data source to update
            dataSourceUpdateClosure()

            // Perform UITableView updates
            deleteRows(at: deletionIndexPaths, with: .automatic)
            insertRows(at: insertIndexPaths, with: .automatic)

            for move in moveIndexPaths {
                moveRow(at: move.origin, to: move.destination)
            }
        })
    }
}
