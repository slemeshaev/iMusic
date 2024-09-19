//
//  SearchMusicPresenter.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import Foundation

protocol SearchMusicPresenter: AnyObject {
    func searchTracks(with keyword: String)
}

class SearchMusicPresenterImpl: SearchMusicPresenter {
    // MARK: - Properties
    weak var view: SearchMusicView?
    var interactor: SearchMusicInteractor?
    
    // MARK: - SearchMusicPresenter
    func searchTracks(with keyword: String) {
        interactor?.fetchTrackList(with: keyword)
    }
}
