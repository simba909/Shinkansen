//
//  CollectionViewDataSourceSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public final class CollectionViewDataSourceSection<DataSource>: NSObject, CollectionViewSection, DataSourceConductor where DataSource: SectionDataSource {
    public typealias HeaderConfigurator = (UICollectionView, IndexPath) -> UICollectionReusableView
    public typealias CellConfigurator = (UICollectionView, DataSource.Item, IndexPath) -> UICollectionViewCell
    public typealias SelectionHandler = (DataSource.Item, IndexPath) -> Void

    private let dataSource: DataSource
    private let cellConfigurator: CellConfigurator

    private var headerConfigurator: HeaderConfigurator?

    public var headerReferenceSize: CGSize?

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

    public func sizeForHeader() -> CGSize {
        if let headerReferenceSize = headerReferenceSize {
            return headerReferenceSize
        }

        return .zero
    }

    public func sizeForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource.items[indexPath.row]
        return cellConfigurator(collectionView, item, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerViewConfigurator = headerConfigurator else {
            let cell: UICollectionReusableView

            switch kind {
            case UICollectionView.elementKindSectionHeader:
                cell = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CollectionViewDataSourceSection.placeholderHeaderReuseIdentifier,
                    for: indexPath)
            case UICollectionView.elementKindSectionFooter:
                cell = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CollectionViewDataSourceSection.placeholderFooterReuseIdentifier,
                    for: indexPath)
            default:
                fatalError("Failed to dequeue placeholder header")
            }

            cell.frame.size.height = 0
            return cell
        }

        return headerViewConfigurator(collectionView, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.items[indexPath.row]
        selectionHandler?(item, indexPath)
    }

    // MARK: - Private functions

    private func registerPlaceholderViews(in collectionView: UICollectionView) {
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
    }
}

// MARK: - Headers
extension CollectionViewDataSourceSection {
    private static var placeholderHeaderReuseIdentifier: String {
        return "EmptyHeader"
    }

    private static var placeholderFooterReuseIdentifier: String {
        return "EmptyFooter"
    }

    public func configureHeader(configurator: @escaping HeaderConfigurator) {
        self.headerConfigurator = configurator
    }
}

// MARK: - DataSourceConductor
extension CollectionViewDataSourceSection {
    public func reloadItems(at indices: [Int], updateClosure: UpdateClosure) {
        conductor?.reloadItems(at: indices, for: self, dataSourceUpdateClosure: updateClosure)
    }

    public func performChanges(_ changes: ChangeSet, updateClosure: UpdateClosure) {
        conductor?.performChanges(changes, for: self, dataSourceUpdateClosure: updateClosure)
    }
}
