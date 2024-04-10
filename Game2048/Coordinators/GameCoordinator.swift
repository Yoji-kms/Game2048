//
//  GameCoordinator.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import UIKit

final class GameCoordinator: Coordinatable {
    let moduleType: Module.ModuleType
    
    private let factory: AppFactory
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = self.factory.makeModule(ofType: self.moduleType)
        let viewController = module.viewController
        (module.viewModel as? GameViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func presentAlert(message: String.LocalizationValue, completion: @escaping ()->Void) {
        let controllerTitle = String(localized: message)
        let alertController = UIAlertController(title: controllerTitle, message: nil, preferredStyle: .alert)
        
        let replayTitle = String(localized: "Replay")
        let replayAction = UIAlertAction(title: replayTitle, style: .default) {_ in 
            alertController.dismiss(animated: true) {
                completion()
            }
        }
        
        let toMenuTitle = String(localized: "Exit to menu")
        let toMenuAction = UIAlertAction(title: toMenuTitle, style: .destructive) {_ in
            alertController.dismiss(animated: true) {
                self.module?.viewController.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addAction(toMenuAction)
        alertController.addAction(replayAction)
        
        self.module?.viewController.present(alertController, animated: true)
    }
}
