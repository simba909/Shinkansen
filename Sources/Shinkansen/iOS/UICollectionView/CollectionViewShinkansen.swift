//
//  CollectionViewShinkansen.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public class CollectionViewShinkansen: NSObject, Shinkansen {
    public private(set) var sections: [CollectionViewSection] = []

    public weak var view: UICollectionView? {
        didSet {
            guard let view = view else { return }
            view.dataSource = self
            view.delegate = self
        }
    }

    public func connectSection(_ section: CollectionViewSection) {
        section.setConductor(self)

        guard let collectionView = view else {
            sections.append(section)
            return
        }

        collectionView.performBatchUpdates({
            let sectionIndex = sections.count
            sections.append(section)
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        })
    }

    @discardableResult
    public func createSection<DataSource: SectionDataSource>(
        from dataSource: DataSource,
        cellConfigurator: @escaping CollectionViewDataSourceSection<DataSource>.CellConfigurator) -> CollectionViewDataSourceSection<DataSource> {

        let section = CollectionViewDataSourceSection(dataSource: dataSource, cellConfigurator: cellConfigurator)
        connectSection(section)

        return section
    }

    public func moveSection(_ section: CollectionViewSection, to destinationIndex: Int) {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == section.id }) else {
            return
        }

        let updateClosure: () -> Void = {
            self.sections.remove(at: sectionIndex)
            self.sections.insert(section, at: destinationIndex)
        }

        guard let collectionView = view else {
            updateClosure()
            return
        }

        collectionView.performBatchUpdates({
            updateClosure()

            collectionView.moveSection(sectionIndex, toSection: destinationIndex)
        })
    }

    public func removeSection(_ section: CollectionViewSection) {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == section.id }) else {
            return
        }

        let updateClosure: () -> Void = {
            self.sections.remove(at: sectionIndex)
        }

        guard let collectionView = view else {
            updateClosure()
            return
        }

        let indexSet = IndexSet(integer: sectionIndex)

        collectionView.performBatchUpdates({
            updateClosure()
            collectionView.deleteSections(indexSet)
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewShinkansen: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        return section.sizeForItem(in: collectionView, at: localIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].sectionInsets
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumLineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sections[section].minimumInteritemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = sections[section]
        return section.sizeForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            in: collectionView)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section = sections[section]
        return section.sizeForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            in: collectionView)
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewShinkansen: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        return section.collectionView(collectionView, numberOfItemsInSection: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        return section.collectionView(collectionView, cellForItemAt: localIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        if let view = section.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewShinkansen: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        section.collectionView?(collectionView, didSelectItemAt: localIndexPath)
    }
}

// MARK: - SectionConductor
extension CollectionViewShinkansen: SectionConductor {
    public func reloadSection(_ section: ShinkansenSection) {
        guard let collectionView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let sectionIndexSet = IndexSet([sectionIndex])
        collectionView.reloadSections(sectionIndexSet)
    }

    public func reloadItems(at indices: [Int], for section: ShinkansenSection, dataSourceUpdateClosure: () -> Void) {
        guard !indices.isEmpty else {
            return
        }

        guard let collectionView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let reloadIndexPaths = indices.map { IndexPath(row: $0, section: sectionIndex) }

        collectionView.performBatchUpdates({
            // Allow the data source to update
            dataSourceUpdateClosure()

            // Perform UICollectionView updates
            collectionView.reloadItems(at: reloadIndexPaths)
        })
    }

    public func performChanges(_ changes: ChangeSet, for section: ShinkansenSection, dataSourceUpdateClosure: () -> Void) {
        guard let collectionView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let insertIndexPaths = changes.insertions.map { IndexPath(row: $0, section: sectionIndex) }
        let deletionIndexPaths = changes.deletions.map { IndexPath(row: $0, section: sectionIndex) }
        let moveIndexPaths = changes.moves.map { move -> (IndexPath, IndexPath) in
            return (IndexPath(row: move.from, section: sectionIndex), IndexPath(row: move.to, section: sectionIndex))
        }

        collectionView.performBatchUpdates({
            // Allow the data source to update
            dataSourceUpdateClosure()

            // Perform UICollectionView updates
            collectionView.deleteItems(at: deletionIndexPaths)
            collectionView.insertItems(at: insertIndexPaths)

            for move in moveIndexPaths {
                collectionView.moveItem(at: move.0, to: move.1)
            }
        })
    }
}
