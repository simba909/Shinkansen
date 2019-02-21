//
//  ReusableView.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-19.
//

import Foundation

public protocol ReusableView {
    static var reuseIdentifier: String { get }
}
