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
        button.setImage("player.pause".uiImage, for: .normal)
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
    
    private lazy var trackPlayerStackView: UIStackView = {
        trackPlayerStackViewSettings()
    }()
    
    private lazy var volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.5
        slider.addTarget(self, action: #selector(handleSoundVolomeSlider), for: .valueChanged)
        return slider
    }()
    
    private lazy var soundValueStackView: UIStackView = {
        soundValueStackViewSettings()
    }()
    
    private let avPlayer: AVPlayer = {
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
        
        guard let duration = avPlayer.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seetTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        avPlayer.seek(to: seetTime)
    }
    
    @objc func handleSoundVolomeSlider() {
        avPlayer.volume = volumeSlider.value
    }
    
    @objc func playStopButtonTapped() {
        if avPlayer.timeControlStatus == .paused {
            avPlayer.play()
            playStopButton.setImage("player.pause".uiImage, for: .normal)
            enlargeTrackCoverImageView()
        } else {
            avPlayer.pause()
            playStopButton.setImage("player.play".uiImage, for: .normal)
            reduceTrackCoverImageView()
        }
    }
    
    @objc func previousTrackTapped() {
        guard let model = delegate?.moveBackForPreviousTrack() else { return }
        configure(with: model)
    }
    
    @objc func nextTrackTapped() {
        guard let model = delegate?.moveForwardForPreviousTrack() else { return }
        configure(with: model)
    }
    
    // MARK: - Private methods
    private func playTrack(previewUrl: String) {
        guard let url = URL(string: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 2)
        let times = [NSValue(time: time)]
        
        avPlayer.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackCoverImageView()
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.backwardLabel.text = time.formattedTime()
            
            let durationTime = self?.avPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
            let durationText = (durationTime - time).formattedTime() ?? ""
            
            self?.forwardLabel.text = "-\(durationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(avPlayer.currentTime())
        let durationSeconds = CMTimeGetSeconds(avPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        performanceProgressSlider.value = Float(percentage)
    }
    
    // MARK: - Animations
    private func enlargeTrackCoverImageView() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                self.trackCoverImageView.transform = .identity
            },
            completion: nil
        )
    }
    
    private func reduceTrackCoverImageView() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                let scale: CGFloat = 0.8
                self.trackCoverImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            },
            completion: nil
        )
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
    
    private func trackPlayerStackViewSettings() -> UIStackView {
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
        
        let maxValueImageView = UIImageView()
        maxValueImageView.translatesAutoresizingMaskIntoConstraints = false
        maxValueImageView.image = "player.max.sound".uiImage
        maxValueImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        maxValueImageView.heightAnchor.constraint(equalTo: maxValueImageView.widthAnchor, multiplier: 0.9).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [minValueImageView, volumeSlider, maxValueImageView])
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
