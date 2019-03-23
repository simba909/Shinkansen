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

            for section in sections {
                section.registerCells(in: view)
            }
        }
    }

    public func connectSection(_ section: CollectionViewSection) {
        section.setConductor(self)

        guard let collectionView = view else {
            sections.append(section)
            return
        }

        section.registerCells(in: collectionView)
        collectionView.performBatchUpdates({
            let sectionIndex = sections.count
            sections.append(section)
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        })
    }

    @discardableResult
    public func createSection<DataSource: SectionDataSource, Cell: UICollectionViewCell>(
        from dataSource: DataSource,
        withCellType cellType: Cell.Type,
        cellConfigurator: @escaping (DataSource.Item, Cell) -> Cell) -> CollectionViewDataSourceSection<DataSource> where Cell: ReusableView {

        return createSection(from: dataSource, sectionCellConfigurator: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(ofType: cellType, for: indexPath)
            return cellConfigurator(item, cell)
        }, sectionCellRegistrator: { collectionView in
            collectionView.register(cellType)
        })
    }

    @discardableResult
    public func createSection<DataSource: SectionDataSource, Cell: UICollectionViewCell>(
        from dataSource: DataSource,
        withCellType cellType: Cell.Type,
        cellConfigurator: @escaping (DataSource.Item, Cell) -> Cell) -> CollectionViewDataSourceSection<DataSource> where Cell: ReusableView & NibLoadableView {

        return createSection(from: dataSource, sectionCellConfigurator: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(ofType: cellType, for: indexPath)
            return cellConfigurator(item, cell)
        }, sectionCellRegistrator: { collectionView in
            collectionView.register(cellType)
        })
    }

    func createSection<DataSource: SectionDataSource>(
        from dataSource: DataSource,
        sectionCellConfigurator: @escaping CollectionViewDataSourceSection<DataSource>.CellConfigurator,
        sectionCellRegistrator: @escaping CollectionViewDataSourceSection<DataSource>.CellRegistrator) -> CollectionViewDataSourceSection<DataSource> {

        let section = CollectionViewDataSourceSection(
            dataSource: dataSource,
            cellConfigurator: sectionCellConfigurator,
            cellRegistrator: sectionCellRegistrator)

        connectSection(section)
        return section
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewShinkansen: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        return section.sizeForItem(in: collectionView, at: localIndexPath)
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
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        if let view = section.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: localIndexPath) {
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewShinkansen: UICollectionViewDelegate {
    //
}

// MARK: - SectionConductor
extension CollectionViewShinkansen: SectionConductor {
    public func registerCellsFor(_ section: Section) {
        guard let collectionView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let section = sections[sectionIndex]
        section.registerCells(in: collectionView)
    }

    public func reloadSection(_ section: Section) {
        guard let collectionView = view,
            let sectionIndex = sections.firstIndex(where: { $0.id == section.id })
            else { return }

        let sectionIndexSet = IndexSet([sectionIndex])
        collectionView.reloadSections(sectionIndexSet)
    }

    public func reloadItems(at indices: [Int], for section: Section, dataSourceUpdateClosure: () -> Void) {
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

    public func performChanges(_ changes: ChangeSet, for section: Section, dataSourceUpdateClosure: () -> Void) {
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

            // Perform UITableView updates
            collectionView.deleteItems(at: deletionIndexPaths)
            collectionView.insertItems(at: insertIndexPaths)

            for move in moveIndexPaths {
                collectionView.moveItem(at: move.0, to: move.1)
            }
        })
    }
}
