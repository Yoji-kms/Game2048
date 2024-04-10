//
//  ViewController.swift
//  Game2048
//
//  Created by Yoji on 04.04.2024.
//

import UIKit

final class GameViewController: UIViewController {
//    MARK: Variables
    private let viewModel: GameViewModelProtocol
    private lazy var gameVariant = self.viewModel.gameVariant
    private lazy var multiplier = self.gameVariant.rows.cgFloat / self.gameVariant.columns.cgFloat
    
    private let internalSpacing: CGFloat = 4
    private lazy var externalSpacing: CGFloat = {
        switch self.gameVariant.shape {
        case .square:
            return 8
        case .rectangle:
            let collectionViewHeight = self.view.frame.height * 0.75
            let collectionViewWidth = collectionViewHeight / multiplier
            let screenWidth = self.view.frame.width
            let spacing = (screenWidth - collectionViewWidth) / 2
            return spacing
        }
    }()
    
//    MARK: Views
    private lazy var replayButton: UIBarButtonItem = {
        let image = UIImage(systemName: "arrow.clockwise")
        let item = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: #selector(replayButtonDidTap)
        )
        
        return item
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()

        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 14)
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var bestResultLabel: UILabel = {
        let label = UILabel()
        
        let best = 0
        label.text = String(localized: "Best: \(best)")
        label.backgroundColor = .white
        label.font = .systemFont(ofSize: 14)
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var gameCollectionViewLayout: UICollectionViewLayout = {
        let collectionViewWidth = self.view.frame.width - (externalSpacing * 2)
        let layout = CollectionViewLayout(
            collectionViewWidth: collectionViewWidth,
            numberOfColumns: self.gameVariant.columns,
            spacing: internalSpacing
        )
        
        return layout
    }()
    
    private lazy var gameCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: gameCollectionViewLayout)
        
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "GameCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.layer.cornerRadius = 5
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
//    MARK: Inits
    init(viewModel: GameViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        setupGestures()
    }

//    MARK: Setups
    private func setupViews() {
        self.view.backgroundColor = .systemGray6
        
        self.view.addSubview(gameCollectionView)
        self.view.addSubview(resultLabel)
        self.view.addSubview(bestResultLabel)
        
        let labelsOffset = self.view.frame.width * 0.25
        
        NSLayoutConstraint.activate([
            self.resultLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.resultLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -labelsOffset),
            
            self.bestResultLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.bestResultLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: labelsOffset),
        
            self.gameCollectionView.topAnchor.constraint(equalTo: self.resultLabel.bottomAnchor, constant: 8),
            self.gameCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: externalSpacing),
            self.gameCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -externalSpacing),
            self.gameCollectionView.heightAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: multiplier, constant: -externalSpacing * 2 * multiplier
            ),
        ])
        
        self.updateLabelsText()
    }

    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.style = .browser
        
        self.navigationItem.rightBarButtonItem = self.replayButton
    }
    
    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures))
        swipeRight.direction = .right
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures))
        swipeDown.direction = .down
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestures))
        swipeUp.direction = .up
        self.gameCollectionView.addGestureRecognizer(swipeLeft)
        self.gameCollectionView.addGestureRecognizer(swipeRight)
        self.gameCollectionView.addGestureRecognizer(swipeDown)
        self.gameCollectionView.addGestureRecognizer(swipeUp)
    }
    
//    MARK: Actions
    @objc private func swipeGestures(gesture: UISwipeGestureRecognizer) {
        var direction: Direction = .left
        
        switch gesture.direction {
        case .right:
            direction = .right
        case .up:
            direction = .up
        case .down:
            direction = .down
        default:
            break
        }
        
        self.viewModel.updateState(input: .swipe(direction) {
            self.updateViews()
        })
    }
    
    @objc private func replayButtonDidTap() {
        self.viewModel.updateState(input: .replay {
            self.updateViews()
        })
    }
    
//    MARK: Methods
    private func updateViews() {
        self.gameCollectionView.reloadData()
        self.updateLabelsText()
    }
    
    private func updateLabelsText() {
        let infinite = self.viewModel.infiniteGame
        let infiniteResultString = String(localized: "Score: \(self.viewModel.result)")
        let regularResultString = String(localized: "Moves: \(self.viewModel.result)")
        self.resultLabel.text = infinite ? infiniteResultString : regularResultString
        
        self.bestResultLabel.text = String(localized: "Best: \(self.viewModel.best)")
    }
}

//  MARK: Extensions
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as? GameCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }

        cell.setup(with: self.viewModel.data[indexPath.row].number)
        
        return cell
    }
}
