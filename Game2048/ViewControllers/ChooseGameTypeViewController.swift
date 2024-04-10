//
//  ChooseGameTypeViewController.swift
//  Game2048
//
//  Created by Yoji on 10.04.2024.
//

import UIKit

final class ChooseGameTypeViewController: UIViewController {
    private let viewModel: ChooseGameTypeViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 30
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        
        return table
    }()
    
    init(viewModel: ChooseGameTypeViewModelProtocol) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.updateState(input: .returned)
    }

    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.style = .browser
        self.navigationItem.title = String(localized: "Results")
    }
}

extension ChooseGameTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let item = self.viewModel.data[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let string = self.viewModel.data[indexPath.row]
        self.viewModel.updateState(input: .didSelectCell(string))
    }
}
