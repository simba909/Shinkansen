//
//  Channel+Differentiable.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-05-19.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Foundation
import DangoKit
import DifferenceKit

extension Channel: Differentiable {
    public var differenceIdentifier: Int {
        return id
    }

    public func isContentEqual(to source: Channel) -> Bool {
        // For now, channels always have the same content
        return true
    }
}
