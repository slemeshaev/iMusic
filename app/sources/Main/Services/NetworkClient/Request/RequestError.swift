//
//  RequestError.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

enum RequestError: Error, Equatable, CustomDebugStringConvertible {
    /// url not formed for request
    case urlMalformed
    
    /// decoding response
    case decodingError(String)
    
    /// fetch data
    case fetchDataError(String)
    
    case noResultsError(String)
    
    // MARK: - CustomDebugStringConvertible
    var debugDescription: String {
        switch self {
        case .urlMalformed:
            return "Url not formed for request error"
        case .decodingError(let message):
            return "Decoding response error: \(message)"
        case .fetchDataError(let message):
            return "Error received retrieving data: \(message)"
        case .noResultsError:
            return "Failed to get results"
        }
    }
}
