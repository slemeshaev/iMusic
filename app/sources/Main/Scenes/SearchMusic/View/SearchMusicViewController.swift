//
//  SearchMusicViewController.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

protocol SearchMusicView: AnyObject {
    func displayTrackList()
}

class SearchMusicViewController: UIViewController {
    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let trackList = [TrackModel]()
    
    // MARK: - Public properties
    var presenter: SearchMusicPresenter!
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        tableViewSettings()
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchMusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// MARK: - SearchMusicView
extension SearchMusicViewController: SearchMusicView {
    func displayTrackList() {
        print(#function, #file)
    }
}

// MARK: - UI
extension SearchMusicViewController {
    // MARK: - Settings
    private func tableViewSettings() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionHeaderTopPadding = 0.0
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
    
    // MARK: - Configure
    private func configureUI() {
        view.backgroundColor = UIColor.white
        setupTableView()
        setupSearchBar()
    }
    
    // MARK: - Setups
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}
