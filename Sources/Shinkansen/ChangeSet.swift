//
//  ChangeSet.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-03-09.
//

import Foundation

public struct ChangeSet {
    public typealias Move = (from: Int, to: Int)

    public let insertions: [Int]
    public let deletions: [Int]
    public let moves: [Move]

    public init(insertions: [Int] = [], deletions: [Int] = [], moves: [Move] = []) {
        self.insertions = insertions
        self.deletions = deletions
        self.moves = moves
    }
}
