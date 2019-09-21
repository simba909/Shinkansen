//
//  Shinkansen.swift
//  Shinkansen
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import Foundation

public protocol Shinkansen {
    associatedtype View: ShinkansenView

    var view: View? { get set }
}
