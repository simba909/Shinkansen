//
//  SimpleTextTableViewCell.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-02-19.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import UIKit
import Shinkansen

class SimpleTextTableViewCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setText(_ text: String) {
        label.text = text
    }
}

extension SimpleTextTableViewCell: ReusableView {}
extension SimpleTextTableViewCell: NibLoadableView {}
