//
//  CMTime+Internal.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 23.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import AVKit

extension CMTime {
    /// Converts CMTime to a string in the format "mm:ss".
    ///
    /// This function analyzes the time value in seconds, extracting hours,
    /// minutes, and seconds, and formats them into a string. If the time value
    /// is invalid (NaN), it returns `nil`.
    ///
    /// - Returns: A string in the format "mm:ss", or `nil` if the time is invalid.
    func formattedTime() -> String? {
        let totalSeconds = CMTimeGetSeconds(self)
        
        guard !totalSeconds.isNaN else { return nil }
        let total = Int(totalSeconds)
        
        let minutes = total / 60
        let seconds = total % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
