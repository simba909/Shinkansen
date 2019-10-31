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

    enum Section {
        case bands
    }

    private let shinkansen = CollectionViewShinkansen<Section>()

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

        let nib = UINib(nibName: "SimpleTextCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "TextCell")

        let headerBundle = Bundle(for: SimpleHeaderSupplementaryView.self)
        let headerNib = UINib(nibName: "SimpleHeaderSupplementaryView", bundle: headerBundle)

        collectionView.register(
            headerNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderCell")

        configureBandsSection()

        shinkansen.view = collectionView
    }
}

// MARK: - Configure bands section
extension DetailViewController {
    func configureBandsSection() {
        let bandsSection = CollectionViewDataSourceSection(
            dataSource: ArrayBackedDataSource(items: ["Metallica", "Slayer"]),
            cellConfigurator: { collectionView, bandName, indexPath in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! SimpleTextCollectionViewCell
                cell.text = bandName

                return cell
        })

        bandsSection.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80)

        bandsSection.configureSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            sizeClosure: { collectionView -> CGSize in
                return CGSize(width: collectionView.bounds.width, height: 32)
        }, configurator: { collectionView, indexPath -> UICollectionReusableView in
            let cell = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "HeaderCell",
                for: indexPath) as! SimpleHeaderSupplementaryView

            cell.title = "Collection View Header"

            return cell
        })

        shinkansen.connectSection(bandsSection, identifiedBy: .bands)
    }
}
