//
//  Section.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol Section {
    var id: Int { get }

    func setConductor(_ conductor: SectionConductor)
}
