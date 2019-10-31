//
//  ShinkansenView.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-06-08.
//

import Foundation

public protocol ShinkansenView: AnyObject {
    associatedtype CellType

    func reloadSection(at index: Int)
    func reloadItems(at indices: IndexSet, inSection section: Int, dataSourceUpdateClosure: () -> Void)
    func applyChanges(_ changes: ChangeSet, inSection section: Int, dataSourceUpdateClosure: () -> Void)
}
