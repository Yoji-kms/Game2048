//
//  GameService.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import Foundation

final class GameService {
    private(set) var data = [CellModel]()
    private(set) var score = 0
    private(set) var moves = 0
    private let numOfRows: Int
    private let numOfColumns: Int
    private let infinite: Bool
    private(set) var lost = false
    private(set) var win = false
    
    init(numOfRows: Int, numOfColumns: Int, infiniteGame infinite: Bool) {
        self.numOfColumns = numOfColumns
        self.numOfRows = numOfRows
        self.infinite = infinite
        let cellCount = numOfRows * numOfColumns
        for index in 0..<cellCount {
            let cell = CellModel(id: index, elementsCount: cellCount, number: nil)
            self.data.append(cell)
        }
        self.addRandom()
        self.addRandom()
    }
    
/*
 В теле метода используются параметры coordinate1 и coordinate2.
 Параметры coordinate1 и coordinate2, в зависимости от направления свайпа, используются как:
    для вертикального свайпа (вверх или вниз):
        coordinate1 - столбец (column)
        coordinate2 - строка (row)
    для горизонтального свайпа (влево или вправо):
        coordinate1 - сторка (row)
        coordinate2 - столбец (column)
*/
    func handle(direction: Direction, completion: @escaping ([CellModel])->Void) {
        var step = 0
        var fromCoordinate2 = 0
        var toCoordinate2 = 0
        var fromCoordinate1 = 0
        var toCoordinate1 = 0
        let prevData = data
        
        switch direction {
        case .down:
            step = -1
            fromCoordinate1 = self.numOfColumns - 1
            toCoordinate1 = -1
            fromCoordinate2 = self.numOfRows - 1
            toCoordinate2 = -1
        case .up:
            step = 1
            fromCoordinate1 = 0
            toCoordinate1 = self.numOfColumns
            fromCoordinate2 = 0
            toCoordinate2 = self.numOfRows
        case .left:
            step = 1
            fromCoordinate1 = 0
            toCoordinate1 = self.numOfRows
            fromCoordinate2 = 0
            toCoordinate2 = self.numOfColumns
        case .right:
            step = -1
            fromCoordinate1 = self.numOfRows - 1
            toCoordinate1 = -1
            fromCoordinate2 = self.numOfColumns - 1
            toCoordinate2 = -1
        }

        for coordinate1 in stride(from: fromCoordinate1, to: toCoordinate1, by: step) {
            self.move(direction: direction, coordinate1: coordinate1, step: step, from: fromCoordinate2, to: toCoordinate2)
            self.merge(direction: direction, coordinate1: coordinate1, step: step, from: fromCoordinate2, to: toCoordinate2)
        }

        if data != prevData {
            self.moves += 1
            self.win = self.infinite ? false : self.checkForWin()
            self.addRandom()
            self.lost = self.checkForLoose()
            completion(data)
        }
    }
    
//    Добавляет число в случайную пустую ячейку
//    С вероятностью 90% число будет 2, с вероятностью 10% - 4
    private func addRandom() {
        let emptyCells = self.data.filter { $0.number == nil }
        if emptyCells.isEmpty { return }
        
        let randomIndex = Int.random(in: 0...emptyCells.count - 1)
        let randomEmptyCellId = emptyCells[randomIndex].id
        
        let randomInt = Int.random(in: 0..<100)
        let number = randomInt < 90 ? 2 : 4
        
        data[randomEmptyCellId].number = number
    }

    
    private func move(
        direction: Direction,
        coordinate1: Int,
        step: Int,
        from: Int,
        to: Int
    ) {
        for _ in stride(from: from, to: to, by: step) {
            for coordinate2 in stride(from: from + step, to: to, by: step) {
                let id = getId(coordinate1: coordinate1, coordinate2: coordinate2, direction: direction)
                let prevId = getId(coordinate1: coordinate1, coordinate2: coordinate2 - step, direction: direction)

                
                if data[prevId].number == nil && data[id].number != nil {
                    data[prevId].number = data[id].number
                    data[id].number = nil
                }
            }
        }
    }
    
    private func merge(
        direction: Direction,
        coordinate1: Int,
        step: Int,
        from: Int,
        to: Int
    ) {
        for coordinate2 in stride(from: from, to: to-step, by: step) {
            let id = getId(coordinate1: coordinate1, coordinate2: coordinate2, direction: direction)
            let nextId = getId(coordinate1: coordinate1, coordinate2: coordinate2 + step, direction: direction)
            guard let number = data[id].number else { break }
            if number == data[nextId].number {
                data[id].number = 2 * number
                self.score += data[id].number ?? 0
                data[nextId].number = nil
                self.move(
                    direction: direction,
                    coordinate1: coordinate1,
                    step: step,
                    from: from,
                    to: to
                )
            }
        }
    }
    
    private func getId(coordinate1: Int, coordinate2: Int, direction: Direction = .left) -> Int {
        switch direction {
        case .up, .down:
            return coordinate2 * self.numOfColumns + coordinate1
        case .left, .right:
            return coordinate1 * self.numOfColumns + coordinate2
        }
    }
    
    private func checkForLoose() -> Bool {
        let isFilled = !data.contains(where: { $0.number == nil })
        
        if isFilled {
            let horizontalCheck = self.checkAxis(direction: .left)
            let verticalCheck = self.checkAxis(direction: .up)
            
            return horizontalCheck && verticalCheck
        }
        
        return false
    }
    
    private func checkForWin() -> Bool {
        return self.data.contains(where: { $0.number == 2048 })
    }
    
    private func checkAxis(direction: Direction) -> Bool {
        for coordinate1 in 0...3 {
            for coordinate2 in 1...3 {
                let id = self.getId(coordinate1: coordinate1, coordinate2: coordinate2, direction: direction)
                let prevId = self.getId(coordinate1: coordinate1, coordinate2: coordinate2-1, direction: direction)
                if data[prevId].number == data[id].number {
                    return false
                }
            }
        }
        return true
    }
}
