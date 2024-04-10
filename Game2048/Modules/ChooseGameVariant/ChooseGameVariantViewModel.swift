//
//  ChooseGameVariantViewModel.swift
//  Game2048
//
//  Created by Yoji on 10.04.2024.
//

import Foundation

final class ChooseGameVariantViewModel: ChooseGameVariantViewModelProtocol {
    weak var coordinator: ChooseGameVariantCoordinator?
    
    private let infinite: Bool
    private(set) var data = GameVariant.allCases.map { $0.string }
    
    init(infinite: Bool) {
        self.infinite = infinite
    }
    
    enum ViewInput {
        case didSelectCell(Int)
        case returned
    }
    
    func updateState(input: ViewInput) {
        switch input {
        case .didSelectCell(let id):
            let gameVariantString = self.data[id]
            let gameVariant = self.getGameVariantBy(string: gameVariantString)
            self.coordinator?.pushResultsViewController(gameVariant: gameVariant, infiniteGame: self.infinite)
        case .returned:
            self.coordinator?.removeAllChildCoordinators()
        }
    }
    
    
    private func getGameVariantBy(string: String) -> GameVariant {
        return GameVariant.allCases.filter { $0.string == string }.first ?? ._4x4
    }
}
