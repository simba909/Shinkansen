//
//  SimpleTextCollectionViewCell.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-02-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import UIKit
import Shinkansen

class SimpleTextCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!

    var text: String? {
        get {
            return label.text
        }
        set {
            label?.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
