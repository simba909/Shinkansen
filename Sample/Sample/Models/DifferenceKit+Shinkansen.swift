//
//  DifferenceKit+Shinkansen.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-05-19.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Foundation
import Shinkansen
import DifferenceKit

extension DifferenceKit.Changeset {
    var reloads: [Int] {
        return elementUpdated.map { $0.element }
    }

    var changes: ChangeSet {
        return ChangeSet(insertions: elementInserted.map { $0.element },
                         deletions: elementDeleted.map { $0.element },
                         moves: elementMoved.map { ChangeSet.Move(from: $0.source.element, to: $0.target.element) })
    }
}
