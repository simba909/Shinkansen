//
//  ShinkansenSection.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol ShinkansenSection: AnyObject {
    var id: Int { get }

    func setConductor(_ conductor: SectionConductor)
}

public extension ShinkansenSection {
    var id: Int {
        return ObjectIdentifier(self).hashValue
    }
}
