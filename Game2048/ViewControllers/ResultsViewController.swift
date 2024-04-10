//
//  ResultsViewController.swift
//  Game2048
//
//  Created by Yoji on 07.04.2024.
//

import UIKit

final class ResultsViewController: UIViewController {
    private let viewModel: ResultsViewModelProtocol
    
    private lazy var resultsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 30
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        
        return table
    }()
    
    init(viewModel: ResultsViewModelProtocol) {
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
        setupNavigation()
    }

    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(resultsTableView)
        
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.style = .browser
        self.navigationItem.title = String(localized: "Results")
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let item = self.viewModel.data[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item
        cell.contentConfiguration = content
        return cell
    }
}
