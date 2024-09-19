//
//  SearchMusicInteractor.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

protocol SearchMusicInteractor {
    func fetchTrackList(for term: String, completion: @escaping (TrackListDto) -> Void)
}

class SearchMusicInteractorImpl: SearchMusicInteractor {
    // MARK: - SearchMusicInteractor
    func fetchTrackList(for term: String, completion: @escaping (TrackListDto) -> Void) {
        print(#function)
    }
}
