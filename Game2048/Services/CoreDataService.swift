//
//  CoreDataService.swift
//  Game2048
//
//  Created by Yoji on 07.04.2024.
//

import Foundation
import CoreData

final class CoreDataService {
    lazy var persistentContaner: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ResultsModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                print("🔴 Core data error: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContaner.viewContext
        return context
    }()
}
