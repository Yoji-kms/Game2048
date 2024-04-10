//
//  Menu.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import Foundation

final class MenuViewModel: MenuViewModelProtocol {
    var coordinator: MenuCoordinator?
    
    private(set) var data: [GameVariant]
    
    private let squareVariants: [GameVariant] = [
        ._4x4,
        ._5x5,
        ._6x6,
        ._8x8
    ]
    
    private let rectangleVariants: [GameVariant] = [
        ._3x5,
        ._4x6,
        ._5x8,
        ._6x9
    ]
    
    init() {
        self.data = squareVariants
    }
    
    enum ViewInput {
        case game(GameVariant, Bool)
        case results
        case square(()->Void)
        case rectangle(()->Void)
        case returned
    }
    
    func updateState(input: ViewInput) {
        switch input {
        case .game(let variant, let infinite):
            self.coordinator?.pushViewController(ofType: .game(variant, infinite))
        case .results:
            self.coordinator?.pushViewController(ofType: .results)
        case .square(let completion):
            self.data = self.squareVariants
            completion()
        case .rectangle(let completion):
            self.data = self.rectangleVariants
            completion()
        case .returned:
            self.coordinator?.removeAllChildCoordinators()
        }
    }
}
