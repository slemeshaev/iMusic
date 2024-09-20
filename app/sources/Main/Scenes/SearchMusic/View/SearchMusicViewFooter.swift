//
//  SearchMusicViewFooter.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 20.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

class SearchMusicViewFooter: UIView {
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        titleSettings()
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        activityIndicatorViewSettings()
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface
    func showLoader() {
        activityIndicatorView.startAnimating()
        titleLabel.text = "Loading..."
    }
    
    func hideLoader() {
        activityIndicatorView.stopAnimating()
        titleLabel.text = nil
    }
}

// MARK: - UI
extension SearchMusicViewFooter {
    // MARK: - Settings
    private func titleSettings() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .gray
        return label
    }
    
    private func activityIndicatorViewSettings() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }
    
    // MARK: - Configure
    private func configureUI() {
        setupActivityIndicatorView()
        setupTitleLabel()
    }
    
    // MARK: - Setups
    private func setupActivityIndicatorView() {
        addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            activityIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 8.0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
