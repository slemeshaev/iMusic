//
//  ImageLoadingError.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 20.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

enum ImageLoadingError: Error {
    case loadingFailed
    
    var localizedDescription: String {
        switch self {
        case .loadingFailed:
            return "Failed to load image"
        }
    }
}
