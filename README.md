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

        // Register your cell
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")

        // Add your sections
        let dataSource = ArrayBackedDataSource(items: ["First", "Second", "Third"])
        shinkansen.createSection(from: dataSource) { collectionView, item, indexPath in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCollectionViewCell
            cell.configureWith(item)

            return cell
        }

        // Set the UICollectionView on the Shinkansen instance:
        shinkansen.view = collectionView
    }
}
```

## Usage

### DataSources
At the heart of Shinkansen is the `SectionDataSource` protocol. To populate your lists with data, start by creating an instance of it:

```swift
class ArrayBackedDataSource<Item>: SectionDataSource {
    let items: [Item]

    init(items: [Item]) {
        self.items = items
    }

    func setConductor(_ conductor: DataSourceConductor) {
        // Unused, for now
    }
}
```

Here we've created a data source backed by a simple `Array` of generic `Item`s. You can use this as-is just like in the example above. Generally speaking though, you'd want to create something a bit more advanced:

```swift
import RxSwift

class RxDataSource<Item>: SectionDataSource {
    private let stream: Observable<[Item]>
    private let disposeBag = DisposeBag()

    private weak var conductor: DataSourceConductor?

    private(set) var items: [Item] = []

    init(stream: Observable<[Item]>) {
        self.stream = stream
    }

    func setConductor(_ conductor: DataSourceConductor) {
        self.conductor = conductor

        stream
            .subscribe(onNext: { [weak self] newItems in
                self?.updateWithNewItems(newItems)
            })
            .disposedBy(disposeBag)
    }

    private func updateWithNewItems(_ newItems: [Item]) {
        let reloads: [Int]
        let changes: ChangeSet
        
        // Use your diffing library of choice to diff items, then use the conductor to apply them.
        // It's _very_ important that you update the data source's items in the updateClosure callback,
        // otherwise you _will_ run into issues with UITableView / UICollectionView state

        conductor?.reloadItems(at: reloads, updateClosure: { [weak self] in
            guard let self = self else { return }

            for updatedIndex in reloads {
                self.items[updatedIndex] = newItems[updatedIndex]
            }
        })

        conductor?.performChanges(changes, updateClosure: { [weak self] in
            self?.items = newItems
        })
    }
}
```

## Installation
The currently preferred way of installation is through [Carthage](https://github.com/Carthage/Carthage):

```
github "isotopsweden/Shinkansen" "master"
```
