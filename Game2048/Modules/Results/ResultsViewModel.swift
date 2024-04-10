//
//  ResultsViewModel.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import Foundation

final class ResultsViewModel: ResultsViewModelProtocol {
    weak var coordinator: ResultsCoordinator?
    
    private(set) var infinite: Bool
    private(set) var gameVariant: GameVariant
    private let resultService: ResultService
    private(set) var data = [String]()
    
    init(gameVariant: GameVariant, infinite: Bool, resultService: ResultService) {
        self.resultService = resultService
        self.infinite = infinite
        self.gameVariant = gameVariant
        self.setupData()
    }
    
    private func setupData() {
        self.resultService.getResultsOf(gameVariant: gameVariant, infinite: infinite) { [weak self] results in
            guard let self else { return }
            self.data = results.map { $0.text }
        }
    }
}
