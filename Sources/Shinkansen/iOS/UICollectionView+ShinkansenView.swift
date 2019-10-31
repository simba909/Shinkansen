//
//  UICollectionView+ShinkansenView.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-06-08.
//

import UIKit

extension UICollectionView: ShinkansenView {
    public typealias CellType = UICollectionViewCell

    public func reloadSection(at index: Int) {
        let indexSet = IndexSet([index])
        reloadSections(indexSet)
    }

    public func reloadItems(at indices: IndexSet, inSection section: Int, dataSourceUpdateClosure: () -> Void) {
        guard !indices.isEmpty else { return }

        performBatchUpdates({
            // Allow the data source to update
            dataSourceUpdateClosure()

            // Perform UICollectionView updates
            let reloadIndexPaths = indices.map { IndexPath(row: $0, section: section) }
            reloadItems(at: reloadIndexPaths)
        })
    }

    public func applyChanges(_ changes: ChangeSet, inSection section: Int, dataSourceUpdateClosure: () -> Void) {
        let insertionIndexPaths = changes.insertions.map { IndexPath(row: $0, section: section) }
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

            // Perform UICollectionView updates
            deleteItems(at: deletionIndexPaths)
            insertItems(at: insertionIndexPaths)

            for move in moveIndexPaths {
                moveItem(at: move.origin, to: move.destination)
            }
        })
    }
}
