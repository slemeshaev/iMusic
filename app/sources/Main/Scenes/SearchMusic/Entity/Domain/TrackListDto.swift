//
//  TrackListDto.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import Foundation

struct TrackListDto: Decodable {
    let results: [TrackDto]
}
