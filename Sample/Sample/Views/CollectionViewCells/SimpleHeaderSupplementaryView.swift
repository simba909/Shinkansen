//
//  SimpleHeaderSupplementaryView.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-03-23.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import UIKit
import Shinkansen

final class SimpleHeaderSupplementaryView: UICollectionReusableView {

    @IBOutlet private weak var titleLabel: UILabel!

    var title: String? {
        get {
            return titleLabel.text
        }

        set {
            titleLabel?.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension SimpleHeaderSupplementaryView: ReusableView {}
extension SimpleHeaderSupplementaryView: NibLoadableView {}
