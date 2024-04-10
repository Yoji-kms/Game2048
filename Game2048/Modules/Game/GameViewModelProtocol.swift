//
//  GameViewModelProtocol.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import Foundation

protocol GameViewModelProtocol: ViewModelProtocol {
    var data: [CellModel] { get }
    var gameVariant: GameVariant { get }
    var result: Int { get }
    var best: Int { get }
    var infiniteGame: Bool { get }
    
    func updateState(input: GameViewModel.ViewInput)
}
