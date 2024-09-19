//
//  NetworkFetcher.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import Foundation

final class NetworkFetcher {
    // MARK: - Interface
    func fetchTracks(with term: String, completion: @escaping (TrackListDto?) -> Void) {
        let request = Request(method: .get, parameters: ["term": term])
        
        networkService.sendRequest(request) { (data, error) in
            if let error = error {
                print(RequestError.fetchDataError(error.localizedDescription))
                completion(nil)
                return
            }
            
            let decode = self.decodeJSON(type: TrackListDto.self, from: data)
            completion(decode)
        }
    }
    
    // MARK: - Private
    private var networkService = NetworkService()
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print(RequestError.decodingError(jsonError.localizedDescription))
            return nil
        }
    }
}
