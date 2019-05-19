//
//  RepositoryDataSource.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-05-19.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Foundation
import Shinkansen
import DangoKit
import DifferenceKit

class RepositoryDataSource<Repo>: SectionDataSource where Repo: Repository, Repo.Item: Differentiable {
    private let repository: Repo

    private weak var conductor: DataSourceConductor?

    private(set) var items: [Repo.Item] = []

    init(repository: Repo) {
        self.repository = repository
    }

    func setConductor(_ conductor: DataSourceConductor) {
        self.conductor = conductor

        refreshData()
    }

    func refreshData() {
        repository.refresh { [weak self] result in
            switch result {
            case .success(let newItems):
                self?.setNewItems(newItems)
            case .failure(let error):
                print("Failed to refresh from repository: \(error)")
            }
        }
    }

    private func setNewItems(_ newItems: [Repo.Item]) {
        let stagedChangeset = StagedChangeset(source: self.items, target: newItems)
        guard let changeset = stagedChangeset.first else { return }

        conductor?.reloadItems(at: changeset.reloads, updateClosure: { [weak self] in
            guard let self = self else { return }

            for updatedIndex in changeset.reloads {
                self.items[updatedIndex] = newItems[updatedIndex]
            }
        })

        conductor?.performChanges(changeset.changes, updateClosure: { [weak self] in
            self?.items = newItems
        })
    }
}
