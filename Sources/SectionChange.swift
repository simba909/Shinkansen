//
//  SectionChange.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public struct SectionChange {
    typealias Move = (from: Int, to: Int)

    let insertions: [Int]
    let deletions: [Int]
    let moves: [Move]
}
