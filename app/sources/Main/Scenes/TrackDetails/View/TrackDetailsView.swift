//
//  TrackDetailsView.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 22.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit
import AVKit

class TrackDetailsView: UIView {
    // MARK: - UI
    private lazy var contentStackView: UIStackView = {
        contentStackViewSettings()
    }()
    
    private lazy var dragDownButton: UIButton = {
        dragDownButtonSettings()
    }()
    
    private lazy var trackCoverImageView: UIImageView = {
        trackCoverViewSettings()
    }()
    
    private lazy var performanceProgressStackView: UIStackView = {
        performanceProgressStackViewSettings()
    }()
    
    private lazy var performanceProgressSlider: UISlider = {
        performanceProgressSliderSettings()
    }()
    
    private lazy var performanceTimeStackView: UIStackView = {
        performanceTimeStackViewSettings()
    }()
    
    
    private lazy var trackTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24.0)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Track Title"
        return label
    }()
    
    private lazy var authorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24.0)
        label.textAlignment = .center
        label.textColor = .systemPink
        label.text = "Author"
        return label
    }()
    
    private lazy var trackInfoStackView: UIStackView = {
        trackInfoStackViewSettings()
    }()
    
    private lazy var trackPlayerStackView: UIStackView = {
        trackPlayerStackViewSettings()
    }()
    
    private lazy var soundValueStackView: UIStackView = {
        soundValueStackViewSettings()
    }()
    
    private let avPlayer: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
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
    func configure(with model: Configurable) {
        trackCoverImageView.setImage(from: model.bigIcon)
        trackTitleLabel.text = model.title
        authorTitleLabel.text = model.subtitle
        
        playTrack(previewUrl: model.previewUrl)
    }
    
    // MARK: - Actions
    @objc func dragDownButtonTapped() {
        removeFromSuperview()
    }
    
    @objc func handlePerformanceProgressSlider() {
        print(#function, #line)
    }
    
    @objc func handleSoundVolomeSlider() {
        print(#function, #line)
    }
    
    // MARK: - Private methods
    private func playTrack(previewUrl: String) {
        guard let url = URL(string: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
}

// MARK: - UI
extension TrackDetailsView {
    // MARK: - Settings
    private func contentStackViewSettings() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }
    
    private func dragDownButtonSettings() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage("player.drag.down".uiImage, for: .normal)
        button.addTarget(self, action: #selector(dragDownButtonTapped), for: .touchUpInside)
        return button
    }
    
    private func trackCoverViewSettings() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }
    
    private func performanceProgressStackViewSettings() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }
    
    private func performanceProgressSliderSettings() -> UISlider {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.0
        slider.addTarget(self, action: #selector(handlePerformanceProgressSlider), for: .valueChanged)
        return slider
    }
    
    private func performanceTimeStackViewSettings() -> UIStackView {
        let backwardLabel = UILabel()
        backwardLabel.translatesAutoresizingMaskIntoConstraints = false
        backwardLabel.textAlignment = .left
        backwardLabel.text = "00:00"
        backwardLabel.textColor = .gray
        
        let forwardLabel = UILabel()
        forwardLabel.translatesAutoresizingMaskIntoConstraints = false
        forwardLabel.textAlignment = .right
        forwardLabel.text = "--:--"
        forwardLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [backwardLabel, forwardLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }
    
    private func trackInfoStackViewSettings() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [trackTitleLabel, authorTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }
    
    private func trackPlayerStackViewSettings() -> UIStackView {
        let backwardButton = UIButton(type: .system)
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.setImage("player.backward".uiImage, for: .normal)
        backwardButton.tintColor = .black
        
        let playStopButton = UIButton(type: .system)
        playStopButton.translatesAutoresizingMaskIntoConstraints = false
        playStopButton.setImage("player.play".uiImage, for: .normal)
        playStopButton.tintColor = .black
        
        let forwardButton = UIButton(type: .system)
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.setImage("player.forward".uiImage, for: .normal)
        forwardButton.tintColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [backwardButton, playStopButton, forwardButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        return stackView
    }
    
    private func soundValueStackViewSettings() -> UIStackView {
        let minValueImageView = UIImageView()
        minValueImageView.translatesAutoresizingMaskIntoConstraints = false
        minValueImageView.image = "player.min.sound".uiImage
        minValueImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        minValueImageView.heightAnchor.constraint(equalTo: minValueImageView.widthAnchor, multiplier: 0.9).isActive = true
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 1
        slider.addTarget(self, action: #selector(handleSoundVolomeSlider), for: .valueChanged)
        
        let maxValueImageView = UIImageView()
        maxValueImageView.translatesAutoresizingMaskIntoConstraints = false
        maxValueImageView.image = "player.max.sound".uiImage
        maxValueImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        maxValueImageView.heightAnchor.constraint(equalTo: maxValueImageView.widthAnchor, multiplier: 0.9).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [minValueImageView, slider, maxValueImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        
        return stackView
    }
    
    // MARK: - Configure
    private func configureUI() {
        backgroundColor = .white
        setupContentStackView()
        
        setupDragDownButton()
        setupTrackCoverView()
        
        setupPerformanceProgressStackView()
        setupPerformanceProgressSlider()
        setupPerformanceTimeStackView()
        
        setupTrackInfoStackView()
        setupTrackPlayerStackView()
        
        setupSoundValueStackView()
    }
    
    // MARK: - Setups
    private func setupContentStackView() {
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            contentStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32.0),
            contentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32.0)
        ])
    }
    
    private func setupDragDownButton() {
        contentStackView.addArrangedSubview(dragDownButton)
        
        NSLayoutConstraint.activate([
            dragDownButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    private func setupTrackCoverView() {
        contentStackView.addArrangedSubview(trackCoverImageView)
        
        NSLayoutConstraint.activate([
            trackCoverImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            trackCoverImageView.heightAnchor.constraint(equalTo: trackCoverImageView.widthAnchor)
        ])
    }
    
    private func setupPerformanceProgressStackView() {
        contentStackView.addArrangedSubview(performanceProgressStackView)
        
        NSLayoutConstraint.activate([
            performanceProgressStackView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ])
    }
    
    private func setupPerformanceProgressSlider() {
        performanceProgressStackView.addArrangedSubview(performanceProgressSlider)
        
        NSLayoutConstraint.activate([
            performanceProgressSlider.widthAnchor.constraint(equalTo: performanceProgressStackView.widthAnchor),
            performanceProgressSlider.heightAnchor.constraint(equalTo: performanceProgressStackView.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupPerformanceTimeStackView() {
        performanceProgressStackView.addArrangedSubview(performanceTimeStackView)
        
        NSLayoutConstraint.activate([
            performanceTimeStackView.widthAnchor.constraint(equalTo: performanceProgressStackView.widthAnchor),
            performanceTimeStackView.heightAnchor.constraint(equalTo: performanceProgressStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupTrackInfoStackView() {
        contentStackView.addArrangedSubview(trackInfoStackView)
        
        NSLayoutConstraint.activate([
            trackInfoStackView.widthAnchor.constraint(equalTo: performanceTimeStackView.widthAnchor),
            trackInfoStackView.heightAnchor.constraint(equalTo: performanceTimeStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupTrackPlayerStackView() {
        contentStackView.addArrangedSubview(trackPlayerStackView)
        
        NSLayoutConstraint.activate([
            trackPlayerStackView.heightAnchor.constraint(equalTo: trackPlayerStackView.widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupSoundValueStackView() {
        contentStackView.addArrangedSubview(soundValueStackView)
        
        NSLayoutConstraint.activate([
            soundValueStackView.heightAnchor.constraint(equalTo: trackPlayerStackView.widthAnchor, multiplier: 0.1)
        ])
    }
}
