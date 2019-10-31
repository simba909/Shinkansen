//
//  SectionConductor.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol SectionConductor: AnyObject {
    typealias UpdateClosure = () -> Void

    func reloadSection(_ section: ShinkansenSection)
    func reloadItems(at indices: [Int], for section: ShinkansenSection, dataSourceUpdateClosure: @escaping UpdateClosure)
    func performChanges(_ changes: ChangeSet, for section: ShinkansenSection, dataSourceUpdateClosure: @escaping UpdateClosure)
}
