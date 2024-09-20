//
//  SearchMusicInteractor.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

protocol SearchMusicInteractor {
    func fetchTrackList(with keyword: String, completion: @escaping (TrackListDto?) -> Void)
}

class SearchMusicInteractorImpl: SearchMusicInteractor {
    // MARK: - Properties
    private let networkFetcher = NetworkFetcher()
    weak var presenter: SearchMusicPresenter?
    
    // MARK: - SearchMusicInteractorInput
    func fetchTrackList(with keyword: String, completion: @escaping (TrackListDto?) -> Void) {
        guard keyword.count >= 3 else { return }
        
        networkFetcher.fetchTracks(with: keyword) { trackList in
            completion(trackList)
        }
    }
}
