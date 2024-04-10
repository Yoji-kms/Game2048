//
//  MenuViewModelProtocol.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import Foundation

protocol MenuViewModelProtocol: ViewModelProtocol {
    var data: [GameVariant] { get }
    func updateState(input: MenuViewModel.ViewInput)
}
