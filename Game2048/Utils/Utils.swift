//
//  Utils.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import UIKit

extension Int {
    var numberOfColumns: Int {
        let double = Double(self)
        let sqrt = sqrt(double)
        let result = sqrt.rounded(.up)
        return Int(result)
    }
    
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    
    var int32: Int32 {
        Int32(self)
    }
    
    var text: String {
        return "\(self)"
    }
}

extension Int? {
    var text: String {
        guard let self else { return "" }
        return "\(self)"
    }
}
