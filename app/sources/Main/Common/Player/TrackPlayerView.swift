//
//  TrackPlayerView.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 24.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

protocol TrackPlayerViewDelegate: AnyObject {
    func userDidRequestPreviousTrack()
    func userDidRequestPlayStopTrack()
    func userDidRequestNextTrack()
}

class TrackPlayerView: UIView {
    // MARK: - Inteface
    var playStopImage = UIImage() {
        didSet {
            playStopButton.setImage(playStopImage, for: .normal)
        }
    }
    
    // MARK: - UI
    private lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage("player.backward".uiImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(previousTrackTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var playStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage("player.stop".uiImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(playStopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage("player.forward".uiImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(nextTrackTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backwardButton, playStopButton, forwardButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    // MARK: - Properties
    weak var delegate: TrackPlayerViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func previousTrackTapped() {
        delegate?.userDidRequestPreviousTrack()
    }
    
    @objc private func playStopButtonTapped() {
        delegate?.userDidRequestPlayStopTrack()
    }
    
    @objc private func nextTrackTapped() {
        delegate?.userDidRequestNextTrack()
    }
    
    // MARK: - Private
    private func configureUI() {
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
