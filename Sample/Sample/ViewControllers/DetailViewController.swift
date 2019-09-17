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

        collectionView.register(SimpleTextCollectionViewCell.self)
        collectionView.registerHeader(SimpleHeaderSupplementaryView.self)

        let dataSource = ArrayBackedDataSource(items: ["Metallica", "Slayer"])
        let bandsSection = shinkansen.createSection(from: dataSource) { collectionView, item, indexPath in
            let cell = collectionView.dequeueReusableCell(ofType: SimpleTextCollectionViewCell.self, for: indexPath)
            cell.setText(item)

            return cell
        }

        bandsSection.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80)
        bandsSection.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 32)
        bandsSection.configureHeader { collectionView, indexPath in
            let cell = collectionView.dequeueReusableHeader(ofType: SimpleHeaderSupplementaryView.self, for: indexPath)
            cell.title = "Collection View Header"

            return cell
        }

        shinkansen.view = collectionView
    }
}
