//
//  TableViewShinkansen.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import UIKit

public class TableViewShinkansen<SectionIdentifier>: NSObject, Shinkansen, UITableViewDelegate, UITableViewDataSource
where SectionIdentifier: Hashable {

    private var sections: [SectionIdentifier: TableViewSection] = [:]
    private var sectionOrder: [SectionIdentifier] = []
    private var conductors: [Conductor<SectionIdentifier>] = []

    public weak var view: UITableView? {
        didSet {
            guard let view = view else { return }
            view.dataSource = self
            view.delegate = self
        }
    }

    public func connectSection(_ section: TableViewSection, identifiedBy identifier: SectionIdentifier) {
        let conductor = createConductor(for: identifier)
        section.setConductor(conductor)
        conductors.append(conductor)

        let updateClosure: () -> Void = {
            self.sections[identifier] = section
            self.sectionOrder.append(identifier)
        }

        guard let tableView = view else {
            updateClosure()
            return
        }

        tableView.performBatchUpdates({
            updateClosure()
            let sectionIndex = sections.count
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
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

        guard let tableView = view else {
            updateClosure()
            return
        }

        tableView.performBatchUpdates({
            updateClosure()

            tableView.moveSection(sectionIndex, toSection: destinationIndex)
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

        guard let tableView = view else {
            updateClosure()
            return
        }

        tableView.performBatchUpdates({
            updateClosure()

            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
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

    public func section(at index: Int) -> TableViewSection? {
        guard sectionOrder.indices.contains(index) else {
            return nil
        }

        let sectionIdentifier = sectionOrder[index]
        return sections[sectionIdentifier]
    }

    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.section(at: section)!
        return section.tableView(tableView, numberOfRowsInSection: 0)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.section(at: indexPath.section)!
        return section.tableView(tableView, cellForRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.section(at: section)!
        return section.tableView?(tableView, titleForHeaderInSection: 0)
    }

    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.section(at: indexPath.section)!
        let localIndexPath = IndexPath(row: indexPath.row, section: 0)
        section.tableView?(tableView, didSelectRowAt: localIndexPath)
    }
}
