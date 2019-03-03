//
//  ArrayBackedDataSource.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-02-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Shinkansen

struct ArrayBackedDataSource: SectionDataSource {
    let items: [String]

    func setConductor(_ conductor: SectionConductor) {
        // Unused
    }
}
