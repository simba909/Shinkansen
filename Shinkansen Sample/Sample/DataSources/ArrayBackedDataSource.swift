//
//  ArrayBackedDataSource.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-02-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Shinkansen

struct ArrayBackedDataSource: SectionDataSource {
    let values: [String]

    var itemCount: Int {
        return values.count
    }

    func setConductor(_ conductor: SectionConductor) {
        // Unused
    }

    func getItem(at index: Int) -> String {
        return values[index]
    }
}
