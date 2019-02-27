//
//  SectionDataSource.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol SectionDataSource {
    associatedtype Item

    var items: [Item] { get }

    func setConductor(_ conductor: SectionConductor)
}
