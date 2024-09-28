//
//  TrackDetailsView.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 22.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit
import AVKit

protocol TrackMovingDelegate: AnyObject {
    func moveBackForPreviousTrack() -> SearchMusicViewCellModel?
    func moveForwardForPreviousTrack() -> SearchMusicViewCellModel?
}

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
    
    private lazy var trackProgressView = TrackProgressView()
    private lazy var trackInfoView = TrackInfoView()
    private lazy var trackPlayerView = TrackPlayerView()
    private lazy var soundVolumeSlider = SoundVolumeSlider()
    
    // MARK: - Public Properties
    var trackCoverImagePath = String() {
        didSet {
            trackCoverImageView.setImage(from: trackCoverImagePath)
        }
    }
    
    var trackTitle = String() {
        didSet {
            trackInfoView.trackTitle = trackTitle
        }
    }
    
    var artistName = String() {
        didSet {
            trackInfoView.artistName = artistName
        }
    }
    
    var playStopPath = String() {
        didSet {
            trackPlayerView.playStopImage = playStopPath.uiImage
        }
    }
    
    var soundVolume: Float = 0.5 {
        didSet {
            soundVolumeSlider.value = soundVolume
        }
    }
    
    var rewindDurationText: String? {
        didSet {
            trackProgressView.backwardText = rewindDurationText
        }
    }
    
    var forwardDurationText: String? {
        didSet {
            trackProgressView.forwardText = forwardDurationText
        }
    }
    
    var progressValue: Float = 0.0 {
        didSet {
            trackProgressView.progressValue = progressValue
        }
    }
    
    var presenter: TrackDetailsPresenter?
    weak var delegate: TrackMovingDelegate?
    
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
        presenter?.configure(with: model)
    }
    
    func enlargeCover() {
        trackCoverImageView.enlargeTrackCover()
    }
    
    func reduceCover() {
        trackCoverImageView.reduceTrackCover()
    }
    
    // MARK: - Actions
    @objc private func dragDownButtonTapped() {
        removeFromSuperview()
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
        
        let scale: CGFloat = 0.8
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        imageView.layer.cornerRadius = 5.0
        
        return imageView
    }
    
    // MARK: - Configure
    private func configureUI() {
        backgroundColor = .white
        setupContentStackView()
        
        setupDragDownButton()
        setupTrackCoverView()
        
        setupTrackProgressView()
        
        setupTrackInfoView()
        setupTrackPlayerView()
        
        setupSoundVolumeSlider()
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
    
    private func setupTrackProgressView() {
        trackProgressView.delegate = self
        
        contentStackView.addArrangedSubview(trackProgressView)
        
        NSLayoutConstraint.activate([
            trackProgressView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            trackProgressView.heightAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupTrackInfoView() {
        contentStackView.addArrangedSubview(trackInfoView)
        
        NSLayoutConstraint.activate([
            trackInfoView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            trackInfoView.heightAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupTrackPlayerView() {
        trackPlayerView.delegate = self
        
        contentStackView.addArrangedSubview(trackPlayerView)
        
        NSLayoutConstraint.activate([
            trackPlayerView.heightAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupSoundVolumeSlider() {
        soundVolumeSlider.delegate = self
        
        contentStackView.addArrangedSubview(soundVolumeSlider)
        
        NSLayoutConstraint.activate([
            soundVolumeSlider.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ])
    }
}

// MARK: - SoundVolumeSliderDelegate
extension TrackDetailsView: SoundVolumeSliderDelegate {
    func didUpdateVolume(with value: Float) {
        presenter?.updateVolume(with: value)
    }
}

// MARK: - TrackPlayerViewDelegate
extension TrackDetailsView: TrackPlayerViewDelegate {
    func userDidRequestPreviousTrack() {
        guard let model = delegate?.moveBackForPreviousTrack() else { return }
        configure(with: model)
    }
    
    func userDidRequestPlayStopTrack() {
        presenter?.togglePlayPause()
    }
    
    func userDidRequestNextTrack() {
        guard let model = delegate?.moveForwardForPreviousTrack() else { return }
        configure(with: model)
    }
}

// MARK: - TrackProgressViewDelegate
extension TrackDetailsView: TrackProgressViewDelegate {
    func didUpdateProgressTrack() {
        let percentage = trackProgressView.progressValue
        presenter?.seek(to: percentage)
    }
}
