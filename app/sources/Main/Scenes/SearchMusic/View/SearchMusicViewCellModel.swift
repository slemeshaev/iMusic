//
//  SearchMusicViewCellModel.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import Foundation

class SearchMusicViewCellModel: Configurable {
    // MARK: - Properties
    private let track: Track
    
    // MARK: - Init
    init(track: Track) {
        self.track = track
    }
    
    // MARK: - Configurable
    var icon: String {
        track.icon
    }
    
    var title: String {
        track.name
    }
    
    var subtitle: String {
        track.artist
    }
}
