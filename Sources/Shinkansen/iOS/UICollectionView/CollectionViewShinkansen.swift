//
//  CollectionViewShinkansen.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import UIKit

public class CollectionViewShinkansen<SectionIdentifier>: NSObject, Shinkansen, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
where SectionIdentifier: Hashable {

    private var sections: [SectionIdentifier: CollectionViewSection] = [:]
    private var sectionOrder: [SectionIdentifier] = []
    private var conductors: [Conductor<SectionIdentifier>] = []

    public weak var view: UICollectionView? {
        didSet {
            guard let view = view else { return }
            view.dataSource = self
            view.delegate = self
        }
    }

    public func connectSection(_ section: CollectionViewSection, identifiedBy identifier: SectionIdentifier) {
        let conductor = createConductor(for: identifier)

        section.setConductor(conductor)
        conductors.append(conductor)

        let updateClosure: () -> Void = {
            self.sections[identifier] = section
            self.sectionOrder.append(identifier)
        }

        guard let collectionView = view else {
            updateClosure()
            return
        }

        collectionView.performBatchUpdates({
            updateClosure()
            let sectionIndex = indexOfSection(identifier)!
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        })
    }

    public func moveSection(_ identifier: SectionIdentifier, to destinationIndex: Int) {
        guard let sectionIndex = sectionOrder.firstIndex(of: identifier) else {
            return
        }

        let updateClosure: () -> Void = {
            self.sectionOrder.remove(at: sectionIndex)
            self.sectionOrder.insert(identifier, at: destinationIndex)
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

    public func removeSection(_ identifier: SectionIdentifier) {
        guard let sectionIndex = sectionOrder.firstIndex(of: identifier) else {
            return
        }

        let updateClosure: () -> Void = {
            self.sections.removeValue(forKey: identifier)
            self.sectionOrder.remove(at: sectionIndex)
            self.conductors.removeAll(where: { $0.sectionIdentifier == identifier })
        }

        guard let collectionView = view else {
            updateClosure()
            return
        }

        collectionView.performBatchUpdates({
            updateClosure()

            let indexSet = IndexSet(integer: sectionIndex)
            collectionView.deleteSections(indexSet)
        })
    }

    public func indexOfSection(_ identifier: SectionIdentifier) -> Int? {
        return sectionOrder.firstIndex(of: identifier)
    }

    public func sectionIdentifier(for index: Int) -> SectionIdentifier? {
        guard sectionOrder.indices.contains(index) else {
            return nil
        }

        return sectionOrder[index]
    }

    public func section(at index: Int) -> CollectionViewSection? {
        guard sectionOrder.indices.contains(index) else {
            return nil
        }

        let sectionIdentifier = sectionOrder[index]
        return sections[sectionIdentifier]
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.section(at: indexPath.section)!
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)

        return section.sizeForItem(in: collectionView, at: localIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.section(at: section)!.sectionInsets
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.section(at: section)!.minimumLineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.section(at: section)!.minimumInteritemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = self.section(at: section)!

        return section.sizeForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, in: collectionView)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let section = self.section(at: section)!

        return section.sizeForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, in: collectionView)
    }

    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionIdentifier = sectionOrder[section]
        let section = sections[sectionIdentifier]!

        return section.collectionView(collectionView, numberOfItemsInSection: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = self.section(at: indexPath.section)!
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)

        return section.collectionView(collectionView, cellForItemAt: localIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.section(at: indexPath.section)!
        if let view = section.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath) {
            return view
        } else {
            return UICollectionReusableView()
        }
    }

    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = self.section(at: indexPath.section)!
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        section.collectionView?(collectionView, didSelectItemAt: localIndexPath)
    }
}
