//
//  ChooseGameTypeViewModelProtocol.swift
//  Game2048
//
//  Created by Yoji on 10.04.2024.
//

import Foundation

protocol ChooseGameTypeViewModelProtocol: ViewModelProtocol {
    var data: [String] { get }
    func updateState(input: ChooseGameTypeViewModel.ViewInput)
}
