//
//  TrackDetailsPresenter.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 24.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit
import AVKit

protocol TrackDetailsPresenter: AnyObject {
    func configure(with model: Configurable)
    func playTrack(previewUrl: String)
    func togglePlayPause()
    func updateVolume()
    func seek(to percentage: Float)
}

class TrackDetailsPresenterImpl: TrackDetailsPresenter {
    private weak var view: TrackDetailsView?
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    // MARK: - Init
    init(view: TrackDetailsView? = nil) {
        self.view = view
    }
    
    // MARK: - TrackDetailsPresenter
    func configure(with model: Configurable) {
        view?.trackCoverImageView.setImage(from: model.bigIcon)
        view?.trackInfoView.trackTitle = model.title
        view?.trackInfoView.artistName = model.subtitle
        
        playTrack(previewUrl: model.previewUrl)
    }
    
    func playTrack(previewUrl: String) {
        guard let url = URL(string: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        view?.trackPlayerView.playStopImage = "player.pause".uiImage
        view?.trackCoverImageView.enlargeTrackCover()
        
        observePlayerCurrentTime()
    }
    
    func togglePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            view?.trackPlayerView.playStopImage = "player.pause".uiImage
            view?.trackCoverImageView.enlargeTrackCover()
        } else {
            player.pause()
            view?.trackPlayerView.playStopImage = "player.play".uiImage
            view?.trackCoverImageView.reduceTrackCover()
        }
    }
    
    func seek(to percentage: Float) {
        guard let duration = player.currentItem?.duration else { return }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        player.seek(to: seekTime)
    }
    
    func updateVolume() {
        player.volume = view?.soundVolumeSlider.value ?? 0.5
    }
    
    // MARK: - Private
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.view?.trackProgressView.backwardText = time.formattedTime()
            
            let durationTime = self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
            let durationText = (durationTime - time).formattedTime() ?? ""
            
            self?.view?.trackProgressView.forwardText = "-\(durationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        view?.trackProgressView.progressValue = Float(percentage)
    }
}
