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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setText(_ text: String) {
        label.text = text
    }
}

extension SimpleTextCollectionViewCell: ReusableView {}
extension SimpleTextCollectionViewCell: NibLoadableView {}
