//
//  ArrayBackedDataSource.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-02-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Shinkansen

class ArrayBackedDataSource<Item>: SectionDataSource {

    private weak var conductor: DataSourceConductor?

    private(set) var items: [Item]

    init(items: [Item]) {
        self.items = items
    }

    func setConductor(_ conductor: DataSourceConductor) {
        self.conductor = conductor
    }
}
