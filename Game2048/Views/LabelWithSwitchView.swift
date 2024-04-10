//
//  LabelWithSwitchView.swift
//  Game2048
//
//  Created by Yoji on 09.04.2024.
//

import UIKit

final class LabelWithSwitchView: UIView {
    var isOn: Bool {
        self._switch.isOn
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var _switch: UISwitch = {
        let _switch = UISwitch()
        
        _switch.onTintColor = .systemIndigo
        _switch.tintColor = .systemGray6
        _switch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        _switch.translatesAutoresizingMaskIntoConstraints = false
    
        return _switch
    }()
    
//    MARK: Lifecycle
    init(text: String) {
        super.init(frame: .zero)
        self.label.text = text
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = 15
        
        self.addSubview(label)
        self.addSubview(_switch)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            _switch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            _switch.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            _switch.heightAnchor.constraint(equalTo: label.heightAnchor)
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
