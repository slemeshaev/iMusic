//
//  TrackDto.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import Foundation

struct TrackDto: Decodable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl60: String
}
