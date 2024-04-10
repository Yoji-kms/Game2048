//
//  MenuViewController.swift
//  Game2048
//
//  Created by Yoji on 07.04.2024.
//

import UIKit

final class MenuViewController: UIViewController {
    private let viewModel: MenuViewModel
    let spacing: CGFloat = 16
    
    private lazy var infiniteSwitch: LabelWithSwitchView = {
        let text = String(localized: "Infinite")
        let _switch = LabelWithSwitchView(text: text)
        
        return _switch
    }()
    
    private lazy var squareButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.backgroundColor = .systemGray

        let image = UIImage(resource: .square)
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        let text = NSAttributedString(attachment: attachment)
        
        button.setAttributedTitle(text, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(squareButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var rectangleButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .systemGray6
        
        let image = UIImage(resource: .rectangle)
        let attachment = NSTextAttachment(image: image)
        attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 20)
        let text = NSAttributedString(attachment: attachment)
        
        button.setAttributedTitle(text, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(rectangleButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var menuCollectionViewLayout: UICollectionViewLayout = {
        let collectionViewWidth = self.view.frame.width - spacing * 2
        let layout = CollectionViewLayout(
            collectionViewWidth: collectionViewWidth,
            numberOfColumns: 2,
            spacing: 12
        )
        
        return layout
    }()
    
    private lazy var menuCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: menuCollectionViewLayout)
        
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.layer.cornerRadius = 5
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var resultsButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(String(localized: "Results"), for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(resultsButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.viewModel.updateState(input: .returned)
    }

    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(infiniteSwitch)
        self.view.addSubview(menuCollectionView)
        self.view.addSubview(squareButton)
        self.view.addSubview(rectangleButton)
        self.view.addSubview(resultsButton)
        
        let buttonsOffset = self.view.frame.width * 0.25
        
        NSLayoutConstraint.activate([
            infiniteSwitch.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            infiniteSwitch.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infiniteSwitch.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            squareButton.topAnchor.constraint(equalTo: infiniteSwitch.bottomAnchor, constant: 16),
            squareButton.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -buttonsOffset + spacing / 2
            ),
            squareButton.heightAnchor.constraint(equalToConstant: 34),
            squareButton.widthAnchor.constraint(equalToConstant: 55),
            
            rectangleButton.topAnchor.constraint(equalTo: infiniteSwitch.bottomAnchor, constant: 16),
            rectangleButton.centerXAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: buttonsOffset - spacing / 2
            ),
            rectangleButton.heightAnchor.constraint(equalToConstant: 34),
            rectangleButton.widthAnchor.constraint(equalToConstant: 55),
            
            menuCollectionView.topAnchor.constraint(equalTo: squareButton.bottomAnchor, constant: 4),
            menuCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            menuCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            menuCollectionView.heightAnchor.constraint(equalTo: menuCollectionView.widthAnchor),
            
            resultsButton.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor, constant: 8),
            resultsButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    @objc private func resultsButtonDidTap() {
        self.viewModel.updateState(input: .results)
    }
    
    @objc private func squareButtonDidTap() {
        self.viewModel.updateState(input: .square {
            self.toggleButtons()
            self.menuCollectionView.reloadData()
        })
    }
    
    @objc private func rectangleButtonDidTap() {
        self.viewModel.updateState(input: .rectangle {
            self.toggleButtons()
            self.menuCollectionView.reloadData()
        })
    }
    
    private func toggleButtons() {
        self.squareButton.isEnabled = !self.squareButton.isEnabled
        self.rectangleButton.isEnabled = !self.rectangleButton.isEnabled
        
        self.squareButton.changeColor()
        self.rectangleButton.changeColor()
    }
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as? MenuCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        
        cell.setup(with: self.viewModel.data[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let variant = self.viewModel.data[indexPath.row]
        let infinite = self.infiniteSwitch.isOn
        self.viewModel.updateState(input: .game(variant, infinite))
    }
}

private extension UIButton {
    func changeColor() {
        self.backgroundColor = self.isEnabled ? .systemGray6 : .systemGray
    }
}
