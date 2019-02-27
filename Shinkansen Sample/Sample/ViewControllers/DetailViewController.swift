//
//  DetailViewController.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-02-27.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import UIKit
import Shinkansen

class DetailViewController: UICollectionViewController {
    private let shinkansen = CollectionViewShinkansen()

    init(title: String) {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)

        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        shinkansen.view = collectionView

        let dataSource = SimpleDataSource(values: ["Metallica", "Slayer"])
        shinkansen.createSection(from: dataSource, withCellType: SimpleTextCollectionViewCell.self) { item, cell in
            cell.setText(item)
            return cell
        }
    }
}
