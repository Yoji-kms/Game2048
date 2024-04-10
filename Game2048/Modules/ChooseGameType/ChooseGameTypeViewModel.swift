//
//  ChooseGameTypeViewModel.swift
//  Game2048
//
//  Created by Yoji on 10.04.2024.
//

import Foundation

final class ChooseGameTypeViewModel: ChooseGameTypeViewModelProtocol {
    weak var coordinator: ChooseGameTypeCoordinator?

    private(set) var data = [
        String(localized: "Regular"),
        String(localized: "Infinite")
    ]
    
    enum ViewInput {
        case didSelectCell(String)
        case returned
    }
    
    func updateState(input: ViewInput) {
        switch input {
        case .didSelectCell(let string):
            let infinite = string == data[1]
            self.coordinator?.pushChooseGameVariantViewController(infiniteGame: infinite)
        case .returned:
            self.coordinator?.removeAllChildCoordinators()
        }
    }
}
