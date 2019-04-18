//
//  CollectionViewDataSourceSection.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public final class CollectionViewDataSourceSection<DataSource>: NSObject, CollectionViewSection, DataSourceConductor where DataSource: SectionDataSource {
    public typealias CellRegistrator = (UICollectionView) -> Void
    public typealias HeaderViewRegistrator = (UICollectionView) -> Void
    public typealias HeaderViewConfigurator = (UICollectionView, IndexPath) -> UICollectionReusableView
    public typealias CellConfigurator = (UICollectionView, IndexPath, DataSource.Item) -> UICollectionViewCell
    public typealias SelectionHandler = (DataSource.Item) -> Void

    private let dataSource: DataSource
    private let cellRegistrator: CellRegistrator
    private let cellConfigurator: CellConfigurator

    private var headerViewRegistrator: HeaderViewRegistrator?
    private var headerViewConfigurator: HeaderViewConfigurator?

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

    public func registerCells(in collectionView: UICollectionView) {
        registerPlaceholderViews(in: collectionView)
        headerViewRegistrator?(collectionView)
        cellRegistrator(collectionView)
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
        return cellConfigurator(collectionView, indexPath, item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerViewConfigurator = headerViewConfigurator else {
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
        selectionHandler?(item)
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

    public func setHeader<Header: UICollectionReusableView>(_ headerType: Header.Type, configurator: @escaping (Header) -> Header) where Header: ReusableView {
        setSectionHeader({ collectionView in
            collectionView.registerHeader(headerType)
        }, configurator: { collectionView, indexPath in
            let header = collectionView.dequeueReusableHeader(ofType: headerType, for: indexPath)
            return configurator(header)
        })
    }

    public func setHeader<Header: UICollectionReusableView>(_ headerType: Header.Type, configurator: @escaping (Header) -> Header) where Header: ReusableView & NibLoadableView {
        setSectionHeader({ collectionView in
            collectionView.registerHeader(headerType)
        }, configurator: { collectionView, indexPath in
            let header = collectionView.dequeueReusableHeader(ofType: headerType, for: indexPath)
            return configurator(header)
        })
    }

    private func setSectionHeader(_ registrator: @escaping HeaderViewRegistrator, configurator: @escaping HeaderViewConfigurator) {
        self.headerViewRegistrator = registrator
        self.headerViewConfigurator = configurator

        conductor?.registerCellsFor(self)
        conductor?.reloadSection(self)
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
