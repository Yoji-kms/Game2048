//
//  ResultService.swift
//  Game2048
//
//  Created by Yoji on 07.04.2024.
//

import Foundation
import CoreData

final class ResultService {
    let coreDataService: CoreDataService
    private(set) var data = [ResultEntity]()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.coreDataService.persistentContaner.newBackgroundContext()
        return context
    }()
    
    init (coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        self.fetch() { results in
            self.data = results
        }
    }
    
    func fetch(completion: @escaping ([ResultEntity]) -> Void) {
        self.backgroundContext.perform { [weak self] in
            guard let self else { return }
            let fetchRequest = ResultEntity.fetchRequest()
            do {
                self.data = try backgroundContext.fetch(fetchRequest).map { $0 }
                self.coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    
                    completion(self.data)
                }
            } catch {
                print("🔻 Error: \(error.localizedDescription)")
                self.data = []
                completion(self.data)
            }
        }
    }
    
    func saveResult(
        _ result: Int,
        infinite: Bool,
        variant: GameVariant
    ) {
        let context = self.backgroundContext
        context.perform { [weak self] in
            guard let self else { return }
            if !self.data.contains(where: {
                if $0.variant == variant.string {
                    return $0.infinite == infinite ? $0.scoreInt == result : $0.movesInt == result
                }
                return false
            }) {
                self.createResult(
                    context: context, result: result, infinite: infinite, variant:  variant
                ) { newDbResult in
                    do {
                        if context.hasChanges {
                            try context.save()
                            self.coreDataService.mainContext.perform { [weak self] in
                                guard let self else { return }
                                self.data.append(newDbResult)
                            }
                        }
                    } catch {
                        print("🔴 Core data error:\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func createResult(
        context: NSManagedObjectContext,
        result: Int,
        infinite: Bool,
        variant: GameVariant,
        completion: @escaping (ResultEntity)->Void
    ) {
        let dbResult = ResultEntity(context: context)
        dbResult.infinite = infinite
        if infinite {
            dbResult.score = result.int32
        } else {
            dbResult.moves = result.int32
        }
        dbResult.variant = variant.string
        completion(dbResult)
    }
    
    func getResultsOf(
        gameVariant variant: GameVariant,
        infinite: Bool,
        completion: @escaping ([Int])->Void)
    {
        let filteredData = self.data
            .filter { $0.infinite == infinite }
            .filter { $0.variant == variant.string }
            
        let filteredSortedData = infinite ?
        filteredData.sorted(by: { $0.score >= $1.score }).map { $0.scoreInt } :
        filteredData.sorted(by: { $0.moves <= $1.moves }).map { $0.movesInt }
        
        completion(filteredSortedData)
    }
    
    func getBestResultOf(
        gameVariant variant: GameVariant,
        infinite: Bool,
        completion: @escaping (Int)->Void
    ) {
        let filteredData = self.data
            .filter { $0.variant == variant.string && $0.infinite == infinite}
        print(filteredData)
        let bestResult = infinite ?
        filteredData.max(by: { $0.score <= $1.score })?.scoreInt :
        filteredData.min(by: { $0.moves <= $1.moves })?.movesInt

        completion(bestResult ?? 0)
    }
}

extension ResultEntity {
    var scoreInt: Int {
        Int(self.score)
    }
    
    var movesInt: Int {
        Int(self.moves)
    }
}
