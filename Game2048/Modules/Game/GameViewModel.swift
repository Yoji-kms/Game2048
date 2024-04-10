//
//  GameViewModel.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import UIKit

final class GameViewModel: GameViewModelProtocol {
    weak var coordinator: GameCoordinator?
    
    private(set) var data = [CellModel]()
    private var service: GameService
    private let resultService: ResultService
    private(set) var infiniteGame: Bool
    private(set) var result: Int = 0
    private(set) var best: Int = 0
    let gameVariant: GameVariant
    
    init(gameVariant variant: GameVariant, infiniteGame: Bool, resultService: ResultService) {
        self.gameVariant = variant
        self.infiniteGame = infiniteGame
        self.resultService = resultService
        
        let rows = self.gameVariant.rows
        let columns = self.gameVariant.columns
        
        self.service = GameService(numOfRows: rows, numOfColumns: columns, infiniteGame: self.infiniteGame)
        self.data = self.service.data
        
        self.updateBest()
    }
    
    enum ViewInput {
        case swipe(Direction, ()->Void)
        case replay(()->Void)
    }
    
    func updateState(input: ViewInput) {
        switch input {
        case .swipe(let direction, let completion):
            self.service.handle(direction: direction) { [weak self] newData in
                guard let self else { return }
                self.data = newData
                self.result = self.infiniteGame ? self.service.score : self.service.moves
                
                if self.service.win {
                    self.resultService.saveResult(
                        self.result,
                        infinite: self.infiniteGame,
                        variant: self.gameVariant
                    )
                    
                    self.coordinator?.presentAlert(message: "Win") { [weak self] in
                        guard let self else { return }
                        self.updateBest()
                        self.replay(completion: completion)
                    }
                } else if self.service.lost && self.infiniteGame {
                    self.resultService.saveResult(
                        self.result,
                        infinite: self.infiniteGame,
                        variant: self.gameVariant
                    )
                    
                    self.coordinator?.presentAlert(message: "Loose") { [weak self] in
                        guard let self else { return }
                        self.updateBest()
                        self.replay(completion: completion)
                    }
                }
                
                completion()
            }
        case .replay(let completion):
            self.replay(completion: completion)
        }
    }
    
    private func replay(completion: @escaping ()->Void) {
        let rows = self.gameVariant.rows
        let columns = self.gameVariant.columns
        self.service = GameService(numOfRows: rows, numOfColumns: columns, infiniteGame: self.infiniteGame)
        self.data = self.service.data
        self.result = self.infiniteGame ? self.service.score : self.service.moves
        completion()
    }
    
    private func updateBest() {
        self.resultService.getBestResultOf(gameVariant: self.gameVariant, infinite: self.infiniteGame) { bestResult in
            self.best = bestResult
        }
    }
}
