//
//  CollectionViewDataSourceSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public class CollectionViewDataSourceSection<DataSource>: NSObject, CollectionViewSection where DataSource: SectionDataSource {

    public typealias CellConfigurator = (UICollectionView, IndexPath, DataSource.Item) -> UICollectionViewCell
    public typealias CellRegistrator = (UICollectionView) -> Void

    public var id: Int = 0

    private let dataSource: DataSource
    private let cellConfigurator: CellConfigurator
    private let cellRegistrator: CellRegistrator

    private weak var conductor: SectionConductor?

    /// The size for each item in this section.
    public var itemSize: CGSize = defaultItemSize {
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
    }

    public func registerCell(in collectionView: UICollectionView) {
        cellRegistrator(collectionView)
    }

    public func sizeForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource.items[indexPath.row]
        return cellConfigurator(collectionView, indexPath, item)
    }
}
