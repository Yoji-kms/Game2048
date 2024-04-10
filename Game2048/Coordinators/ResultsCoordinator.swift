//
//  ResultsCoordinator.swift
//  Game2048
//
//  Created by Yoji on 10.04.2024.
//

import Foundation

import UIKit

final class ResultsCoordinator: Coordinatable {
    let moduleType: Module.ModuleType
    
    private let factory: AppFactory
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    enum ViewControllerType {
        case game(GameVariant, Bool)
        case results
    }
    
    func start() -> UIViewController {
        let module = self.factory.makeModule(ofType: self.moduleType)
        let viewController = module.viewController
        (module.viewModel as? ResultsViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinatable) {
        self.childCoordinators.removeAll(where: { $0 === coordinator })
    }
    
    func removeAllChildCoordinators() {
        self.childCoordinators.removeAll()
    }
    
    func pushResultsViewController(gameVariant variant: GameVariant, infiniteGame infinite: Bool) {
        let childCoordinator = ResultsCoordinator(moduleType: .results(variant, infinite), factory: self.factory)
        
        self.addChildCoordinator(childCoordinator)
        
        let viewControllerToPush = childCoordinator.start()
        guard let navController = module?.viewController.navigationController else { return }
        navController.pushViewController(viewControllerToPush, animated: true)
    }
}
