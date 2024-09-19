//
//  NetworkService.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import Foundation

final class NetworkService {
    // MARK: - Interface
    func sendRequest(_ request: Request, completion: @escaping (Data?, Error?) -> Void) {
        do {
            let urlRequest = try request.buildURLRequest()
            let task = createDataTask(from: urlRequest, completion: completion)
            task.resume()
        } catch {
            completion(nil, error)
        }
    }
    
    // MARK: - Private
    private func createDataTask(from request: URLRequest,
                                completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, RequestError.fetchDataError(error.localizedDescription))
                } else {
                    completion(data, nil)
                }
            }
        }
    }
}
