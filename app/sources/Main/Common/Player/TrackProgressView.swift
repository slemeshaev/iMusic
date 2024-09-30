//
//  TrackProgressView.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 24.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

protocol TrackProgressViewDelegate: AnyObject {
    func didUpdateProgressTrack()
}

class TrackProgressView: UIView {
    // MARK: - Interface
    var backwardText: String? {
        didSet {
            backwardLabel.text = backwardText
        }
    }
    
    var forwardText: String? {
        didSet {
            forwardLabel.text = forwardText
        }
    }
    
    var progressValue: Float = 0.0 {
        didSet {
            progressSlider.value = progressValue
        }
    }
    
    weak var delegate: TrackProgressViewDelegate?
    
    // MARK: - UI
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
    
    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(), for: .normal)
        slider.value = 0.5
        slider.addTarget(self, action: #selector(handleProgressSlider), for: .valueChanged)
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
    @objc private func handleProgressSlider() {
        progressValue = progressSlider.value
        delegate?.didUpdateProgressTrack()
    }
    
    // MARK: - Private
    private func configureUI() {
        setupProgressSlider()
        setupBackwardLabel()
        setupForwardLabel()
    }
    
    private func setupProgressSlider() {
        addSubview(progressSlider)
        
        NSLayoutConstraint.activate([
            progressSlider.widthAnchor.constraint(equalTo: widthAnchor),
            progressSlider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupBackwardLabel() {
        addSubview(backwardLabel)
        
        NSLayoutConstraint.activate([
            backwardLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 8.0),
            backwardLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor, constant: 4.0)
        ])
    }
    
    private func setupForwardLabel() {
        addSubview(forwardLabel)
        
        NSLayoutConstraint.activate([
            forwardLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 8.0),
            forwardLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor, constant: -4.0)
        ])
    }
}
