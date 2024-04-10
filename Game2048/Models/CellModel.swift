//
//  CellModel.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import Foundation

struct CellModel: Equatable {
    static func == (lhs: CellModel, rhs: CellModel) -> Bool {
        lhs.id == rhs.id && lhs.number == rhs.number
    }
    
    let id: Int
    var number: Int?
    var coordinates: Coordinates?
    
    init(id: Int, elementsCount: Int, number: Int?) {
        self.id = id
        self.number = number
        let numberOfColumns = elementsCount.numberOfColumns
        self.coordinates = self.getCoordinatesByColumnsNumber(numberOfColumns)
    }
    
    private func getCoordinatesByColumnsNumber(_ columnsNumber: Int) -> Coordinates {
        let row = self.id / columnsNumber
        let column = self.id % columnsNumber
        return Coordinates(row: row, column: column)
    }
}
