//
//  GameCollectionViewCell.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import UIKit

final class GameCollectionViewCell: UICollectionViewCell {
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .systemGray5
        label.textColor = .black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.numberLabel.backgroundColor = .systemGray5
        self.numberLabel.text = ""
    }
    
    func setup(with number: Int?) {
        self.numberLabel.text = number.text
        self.numberLabel.backgroundColor = number.color
    }
    
    private func setupView() {
        self.addSubview(numberLabel)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.numberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.numberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.numberLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.numberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension Int? {
    var color: UIColor {
        switch self {
        case nil:
            return .systemGray5
        case 2:
            return .systemGray4
        case 4:
            return .systemGray3
        case 8:
            return .systemGray2
        case 16:
            return .systemGray
        case 32:
            return .systemIndigo
        case 64:
            return .systemBlue
        case 128:
            return .systemTeal
        case 256:
            return .systemMint
        case 512:
            return .systemPurple
        case 1024:
            return .systemPink
        case 2048:
            return .systemRed
        default:
            return .systemYellow
        }
    }
}
