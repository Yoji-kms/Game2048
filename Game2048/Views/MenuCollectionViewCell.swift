//
//  MenuCollectionViewCell.swift
//  Game2048
//
//  Created by Yoji on 08.04.2024.
//

import UIKit

final class MenuCollectionViewCell: UICollectionViewCell {
//    MARK: Variables
    private let height: CGFloat = 100
    private var width: CGFloat = 100

    private lazy var imageViewWidthConstraint: NSLayoutConstraint = imageView.widthAnchor.constraint(equalToConstant: width)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//    MARK: Views
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
//    MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lifecycle
    override func prepareForReuse() {
        self.label.text = ""
        self.imageView.image = nil
        self.imageViewWidthConstraint.isActive = false
    }
    
//    MARK: Setups
    func setup(with variant: GameVariant) {
        self.label.text = variant.string
        self.imageView.image = variant.image
        let multiplier = variant.columns.cgFloat / variant.rows.cgFloat
        self.width = self.height * multiplier
        self.imageViewWidthConstraint.isActive = true
    }
    
    private func setupView() {
        self.addSubview(imageView)
        self.addSubview(label)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: self.height),
            
            self.label.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
