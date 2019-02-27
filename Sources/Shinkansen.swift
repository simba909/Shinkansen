//
//  Shinkansen.swift
//  Shinkansen iOS
//
//  Created by Simon Jarbrant on 2019-02-27.
//

import Foundation

protocol Shinkansen {
    associatedtype View

    var view: View? { get set }
}
