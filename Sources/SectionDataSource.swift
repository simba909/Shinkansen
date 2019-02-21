//
//  SectionDataSource.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol SectionDataSource {
    associatedtype Item

    var itemCount: Int { get }

    func setConductor(_ conductor: SectionConductor)
    func getItem(at index: Int) -> Item
}
