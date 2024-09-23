//
//  SearchMusicViewController.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

protocol SearchMusicView: AnyObject {
    func displayTrackList(_ tracks: TrackList)
    func displayFooterView()
}

class SearchMusicViewController: UIViewController {
    // MARK: - Constants
    struct Constants {
        static let cellHeight: CGFloat = 60.0
        static let emptyHeight: CGFloat = 0.0
        static let headerHeight: CGFloat = 250.0
    }
    
    // MARK: - Public properties
    var presenter: SearchMusicPresenter?
    
    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var tracks = TrackList([])
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        tableViewSettings()
    }()
    
    private lazy var footerView = SearchMusicViewFooter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchMusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMusicViewCell.reuseId,
                                                       for: indexPath) as? SearchMusicViewCell,
              let track = tracks.atIndex(indexPath.row) else {
            return UITableViewCell()
        }
        
        let model = SearchMusicViewCellModel(track: track)
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let track = tracks.atIndex(indexPath.row) else { return }
        
        let trackDetailsView = TrackDetailsView(frame: view.bounds)
        trackDetailsView.delegate = self
        
        let window = UIWindow.keyWindow
        window?.addSubview(trackDetailsView)
        
        let model = SearchMusicViewCellModel(track: track)
        trackDetailsView.configure(with: model)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tracks.count > 0 ? Constants.emptyHeight : Constants.headerHeight
    }
}

// MARK: - SearchMusicView
extension SearchMusicViewController: SearchMusicView {
    func displayFooterView() {
        footerView.showLoader()
    }
    
    func displayTrackList(_ tracks: TrackList) {
        self.tracks = tracks
        tableView.reloadData()
        footerView.hideLoader()
    }
}

// MARK: - UISearchBarDelegate
extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTracks(with: searchText)
    }
}

// MARK: - TrackMovingDelegate
extension SearchMusicViewController: TrackMovingDelegate {
    func moveBackForPreviousTrack() -> SearchMusicViewCellModel? {
        return track(isForwardTrack: false)
    }
    
    func moveForwardForPreviousTrack() -> SearchMusicViewCellModel? {
        return track(isForwardTrack: true)
    }
    
    // MARK: - Private
    private func track(isForwardTrack: Bool) -> SearchMusicViewCellModel? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nextRow: Int = isForwardTrack ? (indexPath.row + 1) % tracks.count
                                          : (indexPath.row - 1 + tracks.count) % tracks.count
        let nextIndexPath = IndexPath(row: nextRow, section: indexPath.section)
        
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        
        guard let track = tracks.atIndex(nextRow) else { return nil }
        let model = SearchMusicViewCellModel(track: track)
        
        return model
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
        configureNavigationBar(withTitle: "Music Search")
        setupSearchBar()
        setupTableView()
    }
    
    // MARK: - Setups
    private func setupTableView() {
        tableView.register(SearchMusicViewCell.self, forCellReuseIdentifier: SearchMusicViewCell.reuseId)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.tableFooterView = footerView
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.showsScopeBar = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        searchController.searchBar.searchTextField.textColor = UIColor.black
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
    }
}
