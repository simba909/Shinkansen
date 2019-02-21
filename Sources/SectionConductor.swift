//
//  SectionConductor.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol SectionConductor: AnyObject {
    func section(_ section: Section, reloadedItemsAt indices: [Int], dataSourceUpdateClosure: () -> Void)
    func section(_ section: Section, performedChanges changes: SectionChange, dataSourceUpdateClosure: () -> Void)
}
