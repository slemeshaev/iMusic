//
//  SoundVolumeSlider.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 24.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

protocol SoundVolumeSliderDelegate: AnyObject {
    func didUpdateVolume(with value: Float)
}

class SoundVolumeSlider: UIView {
    // MARK: - Properties
    var value: Float = 0.5 {
        didSet {
            soundVolumeSlider.value = value
        }
    }
    
    weak var delegate: SoundVolumeSliderDelegate?
    
    // MARK: - UI
    private lazy var minVolumeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = "player.min.sound".uiImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var maxVolumeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = "player.max.sound".uiImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var soundVolumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.5
        slider.addTarget(self, action: #selector(handleSoundVolomeSlider), for: .valueChanged)
        return slider
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleSoundVolomeSlider() {
        value = soundVolumeSlider.value
        delegate?.didUpdateVolume(with: value)
    }
    
    // MARK: - Private
    private func configureUI() {
        setupMinVolumeImageView()
        setupMaxVolumeImageView()
        setupSoundVolumeSlider()
    }
    
    private func setupMinVolumeImageView() {
        addSubview(minVolumeImageView)
        
        NSLayoutConstraint.activate([
            minVolumeImageView.topAnchor.constraint(equalTo: topAnchor),
            minVolumeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            minVolumeImageView.heightAnchor.constraint(equalTo: heightAnchor),
            minVolumeImageView.widthAnchor.constraint(equalToConstant: 32.0),
            minVolumeImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupSoundVolumeSlider() {
        addSubview(soundVolumeSlider)
        
        NSLayoutConstraint.activate([
            soundVolumeSlider.topAnchor.constraint(equalTo: topAnchor),
            soundVolumeSlider.leadingAnchor.constraint(equalTo: minVolumeImageView.trailingAnchor, constant: -8.0),
            soundVolumeSlider.trailingAnchor.constraint(equalTo: maxVolumeImageView.leadingAnchor, constant: -8.0),
            soundVolumeSlider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupMaxVolumeImageView() {
        addSubview(maxVolumeImageView)
        
        NSLayoutConstraint.activate([
            maxVolumeImageView.topAnchor.constraint(equalTo: topAnchor),
            maxVolumeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            maxVolumeImageView.heightAnchor.constraint(equalTo: heightAnchor),
            maxVolumeImageView.widthAnchor.constraint(equalToConstant: 32.0),
            maxVolumeImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
