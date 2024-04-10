//
//  GameVariant.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import UIKit

enum GameVariant: CaseIterable {
    case _4x4
    case _5x5
    case _6x6
    case _8x8
    case _3x5
    case _4x6
    case _5x8
    case _6x9
    
    var string: String {
        switch self {
        case ._4x4:
            return "4x4"
        case ._5x5:
            return "5x5"
        case ._6x6:
            return "6x6"
        case ._8x8:
            return "8x8"
        case ._3x5:
            return "3x5"
        case ._4x6:
            return "4x6"
        case ._5x8:
            return "5x8"
        case ._6x9:
            return "6x9"
        }
    }
    
    var image: UIImage {
        switch self {
        case ._4x4:
            return UIImage(resource: ._4X4)
        case ._5x5:
            return UIImage(resource: ._5X5)
        case ._6x6:
            return UIImage(resource: ._6X6)
        case ._8x8:
            return UIImage(resource: ._8X8)
        case ._3x5:
            return UIImage(resource: ._3X5)
        case ._4x6:
            return UIImage(resource: ._4X6)
        case ._5x8:
            return UIImage(resource: ._5X8)
        case ._6x9:
            return UIImage(resource: ._6X9)
        }
    }
    
    var rows: Int {
        let coordinates = self.string.split(separator: "x").map { Int($0) ?? 0 }
        return coordinates[1]
//        switch self {
//        case ._4x4:
//            return 4
//        case ._5x5, ._3x5:
//            return 5
//        case ._6x6, ._4x6:
//            return 6
//        case ._8x8, ._5x8:
//            return 8
//        case ._6x9:
//            return 9
//        }
    }
    
    var columns: Int {
        let coordinates = self.string.split(separator: "x").map { Int($0) ?? 0 }
        return coordinates[0]
//        switch self {
//        case ._4x4, ._5x5, ._6x6, ._8x8:
//            return self.rows
//        case ._3x5:
//            return 3
//        case ._4x6:
//            return 4
//        case ._5x8:
//            return 5
//        case ._6x9:
//            return 6
//        }
    }
    
    var shape: Shape {
        switch self {
        case ._4x4, ._5x5, ._6x6, ._8x8:
            return .square
        case ._3x5, ._4x6, ._5x8, ._6x9:
            return .rectangle
        }
    }
}

enum Shape {
    case square
    case rectangle
}
