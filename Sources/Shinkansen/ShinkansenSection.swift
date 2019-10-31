//
//  ShinkansenSection.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol ShinkansenSection: AnyObject {
    func setConductor(_ conductor: SectionConductor)
}
