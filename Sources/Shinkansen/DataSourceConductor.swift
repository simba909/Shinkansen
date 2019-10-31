//
//  DataSourceConductor.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-03-09.
//

import Foundation

public protocol DataSourceConductor: AnyObject {
    typealias UpdateClosure = () -> Void

    func reloadItems(at indices: [Int], updateClosure: @escaping UpdateClosure)
    func performChanges(_ changes: ChangeSet, updateClosure: @escaping UpdateClosure)
}
