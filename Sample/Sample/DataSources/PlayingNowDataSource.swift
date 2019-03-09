//
//  PlayingNowDataSource.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-03-09.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Foundation
import Shinkansen
import DangoKit

final class PlayingNowDataSource: SectionDataSource {
    private let repository: PlayingNowRepository
    private weak var conductor: DataSourceConductor?

    private(set) var items: [PlayingNowInfo] = []

    init(repository: PlayingNowRepository) {
        self.repository = repository
    }

    func setConductor(_ conductor: DataSourceConductor) {
        self.conductor = conductor

        repository.refresh { [weak self] result in
            switch result {
            case .success(let playingNowList):
                self?.handlePlayingNowUpdated(playingNowList)
            case .failure(let error):
                print("Failed to refresh from repository: \(error)")
            }
        }
    }

    private func handlePlayingNowUpdated(_ newInfo: [PlayingNowInfo]) {
        let changeSet = ChangeSet(insertions: Array(newInfo.indices))
        conductor?.performChanges(changeSet, updateClosure: { [weak self] in
            self?.items = newInfo
        })
    }
}
