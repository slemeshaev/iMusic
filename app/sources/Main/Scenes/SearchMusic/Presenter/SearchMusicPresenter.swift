//
//  SearchMusicPresenter.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import Foundation

protocol SearchMusicPresenter {
    func viewDidLoad()
}

class SearchMusicPresenterImpl: SearchMusicPresenter {
    // MARK: - Properties
    weak var view: SearchMusicView?
    var interactor: SearchMusicInteractor
    
    // MARK: - Init
    init(interactor: SearchMusicInteractor) {
        self.interactor = interactor
    }
    
    // MARK: - ToDoListPresenter
    func viewDidLoad() {
        print(#function, #file)
    }
}
