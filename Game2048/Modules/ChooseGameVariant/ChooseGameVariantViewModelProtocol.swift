//
//  ChooseGameVariantViewModelProtocol.swift
//  Game2048
//
//  Created by Yoji on 10.04.2024.
//

import Foundation

protocol ChooseGameVariantViewModelProtocol: ViewModelProtocol {
    var data: [String] { get }
    func updateState(input: ChooseGameVariantViewModel.ViewInput)
}
