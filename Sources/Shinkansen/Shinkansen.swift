//
//  Shinkansen.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import Foundation

public protocol Shinkansen: AnyObject {
    associatedtype View: ShinkansenView
    associatedtype SectionIdentifier: Hashable

    var view: View? { get set }

    func indexOfSection(_ identifier: SectionIdentifier) -> Int?
    func sectionIdentifier(for index: Int) -> SectionIdentifier?
}

extension Shinkansen {
    func createConductor(for sectionIdentifier: SectionIdentifier) -> Conductor<SectionIdentifier> {
        return Conductor(
            sectionIdentifier: sectionIdentifier,
            reloadClosure: { [weak self] identifier in
                guard let sectionIndex = self?.indexOfSection(identifier) else {
                    return
                }

                self?.view?.reloadSection(at: sectionIndex)

            }, itemReloadClosure: { [weak self] identifier, indices, dataSourceUpdateClosure in
                guard let sectionIndex = self?.indexOfSection(identifier) else {
                    dataSourceUpdateClosure()
                    return
                }

                self?.view?.reloadItems(at: indices, inSection: sectionIndex, dataSourceUpdateClosure: dataSourceUpdateClosure)

            }, performChangesClosure: { [weak self] identifier, changes, dataSourceUpdateClosure in
                guard let sectionIndex = self?.indexOfSection(identifier) else {
                    dataSourceUpdateClosure()
                    return
                }

                self?.view?.applyChanges(changes, inSection: sectionIndex, dataSourceUpdateClosure: dataSourceUpdateClosure)
        })
    }
}
