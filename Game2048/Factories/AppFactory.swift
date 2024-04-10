//
//  AppFactory.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import UIKit

final class AppFactory {
    private let resultsService: ResultService
    
    init(resultService: ResultService) {
        self.resultsService = resultService
    }
    
    func makeModule(ofType type: Module.ModuleType) -> Module {
        switch type {
        case .menu:
            let viewModel = MenuViewModel()
            let viewController: UIViewController = MenuViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            return Module(type: .menu, viewModel: viewModel, viewController: navController)
        case .game(let variant, let infinite):
            let viewModel = GameViewModel(gameVariant: variant, infiniteGame: infinite, resultService: self.resultsService)
            let viewController: UIViewController = GameViewController(viewModel: viewModel)
            return Module(type: .game(variant, infinite), viewModel: viewModel, viewController: viewController)
        case .results(let variant, let infinite):
            let viewModel = ResultsViewModel(gameVariant: variant, infinite: infinite, resultService: self.resultsService)
            let viewController: UIViewController = ResultsViewController(viewModel: viewModel)
            return Module(type: .results(variant, infinite), viewModel: viewModel, viewController: viewController)
        case .chooseGameType:
            let viewModel = ChooseGameTypeViewModel()
            let viewController: UIViewController = ChooseGameTypeViewController(viewModel: viewModel)
            return Module(type: .chooseGameType, viewModel: viewModel, viewController: viewController)
        case .chooseGameVariant(let infinite):
            let viewModel = ChooseGameVariantViewModel(infinite: infinite)
            let viewController: UIViewController = ChooseGameVariantViewController(viewModel: viewModel)
            return Module(type: .chooseGameVariant(infinite), viewModel: viewModel, viewController: viewController)
        }
    }
}
