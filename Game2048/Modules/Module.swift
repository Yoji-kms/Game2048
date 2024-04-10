//
//  Module.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import UIKit

struct Module {
    enum ModuleType {
        case menu
        case game(GameVariant, Bool)
        case chooseGameType
        case chooseGameVariant(Bool)
        case results(GameVariant, Bool)
    }
    
    let type: ModuleType
    let viewModel: ViewModelProtocol
    let viewController: UIViewController
}
