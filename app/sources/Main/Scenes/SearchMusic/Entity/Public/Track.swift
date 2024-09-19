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
    
    // MARK: - Equatable
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }
}
