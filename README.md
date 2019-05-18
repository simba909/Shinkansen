# 🚅 Shinkansen

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Shinkansen is a framework for declaratively building your `UITableView` or `UICollectionView`:

```swift
import UIKit
import Shinkansen

class ViewController: UICollectionViewController {

    private let shinkansen = CollectionViewShinkansen()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add your sections
        let dataSource = ArrayBackedDataSource(items: ["First", "Second", "Third"])
        shinkansen.createSection(from: dataSource, withCellType: SimpleTextCollectionViewCell.self) { item, cell in
            cell.label.text = item
            return cell
        }
        
        // Set the UICollectionView on the Shinkansen instance:
        shinkansen.view = collectionView
    }
}
```

## Installation
The currently preferred way of installation is through [Carthage](https://github.com/Carthage/Carthage):

```
github "simba909/Shinkansen" "master"
```
