//
//  CollectionViewLayout.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import UIKit

final class CollectionViewLayout: UICollectionViewFlowLayout {
    private let spacing: CGFloat
    private let width: CGFloat
    
    init(collectionViewWidth width: CGFloat, numberOfColumns columns: Int, spacing: CGFloat) {
        self.spacing = spacing
        self.width = width
        super.init()
        setupLayout(numberOfColumns: columns)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(numberOfColumns columns: Int) {
        let itemWidth = self.getItemSizeByColumnsNumber(columns.cgFloat)
        self.minimumLineSpacing = self.spacing
        self.minimumInteritemSpacing = spacing
        self.sectionInset = UIEdgeInsets(
            top: self.spacing,
            left: self.spacing,
            bottom: self.spacing,
            right: self.spacing
        )
        self.scrollDirection = .vertical
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func getItemSizeByColumnsNumber(_ columnsNumber: CGFloat) -> CGFloat {
        let widthWithPadding = self.width - (self.spacing * 2)
        let itemWidth = (widthWithPadding - self.spacing * (columnsNumber - 1)) / columnsNumber
        return itemWidth
    }
}
