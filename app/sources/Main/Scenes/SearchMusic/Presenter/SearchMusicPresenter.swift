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
        view?.displayFooterView()
        
        interactor?.fetchTrackList(with: keyword) { [weak self] trackListDto in
            guard let self = self else { return }
            
            if let results = trackListDto?.results {
                let list = TrackList([])
                
                results.forEach { trackDto in
                    list.add(Track(dto: trackDto))
                }
                
                self.view?.displayTrackList(list)
            } else {
                print(RequestError.noResultsError)
            }
        }
    }
}
