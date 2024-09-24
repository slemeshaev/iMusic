//
//  TrackInfoView.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 24.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

class TrackInfoView: UIView {
    // MARK: - Interface
    var trackTitle: String = "Track Title" {
        didSet {
            trackTitleLabel.text = trackTitle
        }
    }
    
    var artistName: String = "Artist Name"{
        didSet {
            artistNameLabel.text = artistName
        }
    }
    
    // MARK: - UI
    private lazy var trackTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24.0)
        label.textAlignment = .center
        label.textColor = .black
        label.text = trackTitle
        return label
    }()
    
    private lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24.0)
        label.textAlignment = .center
        label.textColor = .systemPink
        label.text = artistName
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func configureUI() {
        setupTrackTitleLabel()
        setupArtistNameLabel()
    }
    
    private func setupTrackTitleLabel() {
        addSubview(trackTitleLabel)
        
        NSLayoutConstraint.activate([
            trackTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            trackTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupArtistNameLabel() {
        addSubview(artistNameLabel)
        
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: trackTitleLabel.bottomAnchor, constant: 8.0),
            artistNameLabel.centerXAnchor.constraint(equalTo: trackTitleLabel.centerXAnchor)
        ])
    }
}
