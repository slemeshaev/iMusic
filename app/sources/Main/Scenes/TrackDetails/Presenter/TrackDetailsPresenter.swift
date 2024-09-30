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
    func updateVolume(with value: Float)
    func seek(to percentage: Float)
}

class TrackDetailsPresenterImpl: TrackDetailsPresenter {
    // MARK: - Properties
    private weak var view: TrackDetailsView?
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    // MARK: - Init
    init(view: TrackDetailsView) {
        self.view = view
    }
    
    // MARK: - TrackDetailsPresenter
    func configure(with model: Configurable) {
        view?.trackCoverImagePath = model.bigIcon
        view?.trackTitle = model.title
        view?.artistName = model.subtitle
        
        playTrack(previewUrl: model.previewUrl)
    }
    
    func playTrack(previewUrl: String) {
        guard let url = URL(string: previewUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        view?.playStopPath = "player.pause"
        view?.enlargeCover()
        
        observePlayerCurrentTime()
    }
    
    func togglePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            
            view?.playStopPath = "player.pause"
            view?.enlargeCover()
        } else {
            player.pause()
            
            view?.playStopPath = "player.play"
            view?.reduceCover()
        }
    }
    
    func seek(to percentage: Float) {
        guard let duration = player.currentItem?.duration else { return }
        
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        player.seek(to: seekTime)
    }
    
    func updateVolume(with value: Float) {
        player.volume = value
    }
    
    // MARK: - Private
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.view?.rewindDurationText = time.formattedTime()
            
            let durationTime = self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
            let durationText = (durationTime - time).formattedTime() ?? ""
            
            self.view?.forwardDurationText = "-\(durationText)"
            self.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        view?.progressValue = Float(percentage)
    }
}
