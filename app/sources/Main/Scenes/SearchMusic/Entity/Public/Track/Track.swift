//
//  Track.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

struct Track: Equatable {
    let id: String
    let icon: String
    let name: String
    let artist: String
    let previewUrl: String
    
    // MARK: - Equatable
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Mapping
extension Track {
    init(dto: TrackDto) {
        self.id = String(dto.trackId)
        self.icon = dto.artworkUrl100 ?? ""
        self.name = dto.trackName
        self.artist = dto.artistName
        self.previewUrl = dto.previewUrl ?? ""
    }
}
