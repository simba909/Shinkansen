//
//  CollectionViewDataSourceSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public final class CollectionViewDataSourceSection<DataSource>: NSObject, CollectionViewSection where DataSource: SectionDataSource {

    public typealias SupplementaryViewConfigurator = (UICollectionView, IndexPath) -> UICollectionReusableView
    public typealias SupplementaryViewSizeClosure = (UICollectionView) -> CGSize
    public typealias CellConfigurator = (UICollectionView, DataSource.Item, IndexPath) -> UICollectionViewCell
    public typealias SelectionHandler = (DataSource.Item, IndexPath) -> Void

    private let dataSource: DataSource
    private let cellConfigurator: CellConfigurator

    private var supplementaryViewSizeClosures: [String: SupplementaryViewSizeClosure] = [:]
    private var supplementaryViewConfigurators: [String: SupplementaryViewConfigurator] = [:]

    private weak var conductor: SectionConductor?

    /// The size for each item in this section.
    public var itemSize: CGSize = defaultItemSize {
        didSet {
            conductor?.reloadSection(self)
        }
    }

    public var sectionInsets: UIEdgeInsets = .zero {
        didSet {
            conductor?.reloadSection(self)
        }
    }

    public var minimumLineSpacing: CGFloat = .zero {
        didSet {
            conductor?.reloadSection(self)
        }
    }

    public var minimumInteritemSpacing: CGFloat = .zero {
        didSet {
            conductor?.reloadSection(self)
        }
    }

    public var selectionHandler: SelectionHandler?

    public init(dataSource: DataSource, cellConfigurator: @escaping CellConfigurator) {
        self.dataSource = dataSource
        self.cellConfigurator = cellConfigurator
        super.init()
    }

    public func setConductor(_ conductor: SectionConductor) {
        self.conductor = conductor
        dataSource.setConductor(self)
    }

    // MARK: CollectionViewSection

    public func sizeForSupplementaryView(ofKind kind: String, in collectionView: UICollectionView) -> CGSize {
        guard let sizeClosure = supplementaryViewSizeClosures[kind] else {
            return .zero
        }

        return sizeClosure(collectionView)
    }

    public func sizeForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    // MARK: UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource.items[indexPath.row]
        return cellConfigurator(collectionView, item, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let configurator = supplementaryViewConfigurators[kind] else {
            fatalError("viewForSupplementaryElementOfKind called for unknown kind: \(kind)")
        }

        return configurator(collectionView, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.items[indexPath.row]
        selectionHandler?(item, indexPath)
    }
}

// MARK: - Supplementary Views
extension CollectionViewDataSourceSection {
    public func configureSupplementaryView(ofKind kind: String,
                                           sizeClosure: @escaping SupplementaryViewSizeClosure,
                                           configurator: @escaping SupplementaryViewConfigurator) {

        supplementaryViewSizeClosures[kind] = sizeClosure
        supplementaryViewConfigurators[kind] = configurator
    }
}

// MARK: - DataSourceConductor
extension CollectionViewDataSourceSection: DataSourceConductor {
    public func reloadItems(at indices: [Int], updateClosure: @escaping UpdateClosure) {
        conductor?.reloadItems(at: indices, for: self, dataSourceUpdateClosure: updateClosure)
    }

    public func performChanges(_ changes: ChangeSet, updateClosure: @escaping UpdateClosure) {
        conductor?.performChanges(changes, for: self, dataSourceUpdateClosure: updateClosure)
    }
}
