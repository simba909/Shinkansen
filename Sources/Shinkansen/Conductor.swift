//
//  Conductor.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-10-21.
//

import Foundation

class Conductor<SectionIdentifier>: SectionConductor where SectionIdentifier: Hashable {

    typealias DataSourceUpdateClosure = () -> Void
    typealias ReloadClosure = (SectionIdentifier) -> Void
    typealias ItemReloadClosure = (SectionIdentifier, _ indices: IndexSet, _ dataSourceUpdateClosure: DataSourceUpdateClosure) -> Void
    typealias PerformChangesClosure = (SectionIdentifier, _ changes: ChangeSet, _ dataSourceUpdateClosure: DataSourceUpdateClosure) -> Void

    private let reloadClosure: ReloadClosure
    private let itemReloadClosure: ItemReloadClosure
    private let performChangesClosure: PerformChangesClosure

    let sectionIdentifier: SectionIdentifier

    init(sectionIdentifier: SectionIdentifier,
         reloadClosure: @escaping Conductor<SectionIdentifier>.ReloadClosure,
         itemReloadClosure: @escaping Conductor<SectionIdentifier>.ItemReloadClosure,
         performChangesClosure: @escaping Conductor<SectionIdentifier>.PerformChangesClosure) {

        self.sectionIdentifier = sectionIdentifier
        self.reloadClosure = reloadClosure
        self.itemReloadClosure = itemReloadClosure
        self.performChangesClosure = performChangesClosure
    }

    func reloadSection(_ section: ShinkansenSection) {
        reloadClosure(sectionIdentifier)
    }

    func reloadItems(at indices: [Int], for section: ShinkansenSection, dataSourceUpdateClosure: () -> Void) {
        itemReloadClosure(sectionIdentifier, IndexSet(indices), dataSourceUpdateClosure)
    }

    func performChanges(_ changes: ChangeSet, for section: ShinkansenSection, dataSourceUpdateClosure: () -> Void) {
        performChangesClosure(sectionIdentifier, changes, dataSourceUpdateClosure)
    }
}
