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
    
    private lazy var backwardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "00:00"
        label.textColor = .gray
        return label
    }()
    
    private lazy var forwardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "--:--"
        label.textColor = .gray
        return label
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
    
    private lazy var trackPlayerView = TrackPlayerView()
    private lazy var soundVolumeSlider = SoundVolumeSlider()
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    // MARK: - Properties
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
        trackCoverImageView.setImage(from: model.bigIcon)
        trackTitleLabel.text = model.title
        authorTitleLabel.text = model.subtitle
        
        playTrack(previewUrl: model.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
    }
    
    // MARK: - Actions
    @objc func dragDownButtonTapped() {
        removeFromSuperview()
    }
    
    @objc func handlePerformanceProgressSlider() {
        let percentage = performanceProgressSlider.value
        
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seetTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        player.seek(to: seetTime)
    }
    
    // MARK: - Private methods
    private func playTrack(previewUrl: String) {
        guard let url = URL(string: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 2)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.trackCoverImageView.enlargeTrackCover()
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.backwardLabel.text = time.formattedTime()
            
            let durationTime = self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
            let durationText = (durationTime - time).formattedTime() ?? ""
            
            self?.forwardLabel.text = "-\(durationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        performanceProgressSlider.value = Float(percentage)
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
    
    private func setupTrackPlayerView() {
        trackPlayerView.delegate = self
        trackPlayerView.playStopImage = "player.pause".uiImage
        
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
    func didUpdateVolume() {
        player.volume = soundVolumeSlider.value
    }
}

// MARK: - TrackPlayerViewDelegate
extension TrackDetailsView: TrackPlayerViewDelegate {
    func userDidRequestPreviousTrack() {
        guard let model = delegate?.moveBackForPreviousTrack() else { return }
        configure(with: model)
    }
    
    func userDidRequestPlayStopTrack() {
        if player.timeControlStatus == .paused {
            player.play()
            trackPlayerView.playStopImage = "player.pause".uiImage
            trackCoverImageView.enlargeTrackCover()
        } else {
            player.pause()
            trackPlayerView.playStopImage = "player.play".uiImage
            trackCoverImageView.reduceTrackCover()
        }
    }
    
    func userDidRequestNextTrack() {
        guard let model = delegate?.moveForwardForPreviousTrack() else { return }
        configure(with: model)
    }
}
