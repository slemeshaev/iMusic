//
//  TrackList.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

class TrackList {
    // MARK: - Init
    init(_ list: [Track]) {
        self.list = list
    }
    
    // MARK: - Properties
    private var list: [Track]
    
    var allItems: [Track] {
        return list
    }
    
    var count: Int {
        return list.count
    }
    
    // MARK: - Interface
    func add(_ track: Track) {
        if !track.id.isEmpty {
            list.append(track)
        }
    }
    
    func atIndex(_ index: Int) -> Track? {
        if (index < 0 || index > count - 1) {
            return nil
        }
        
        return list[index]
    }
    
    func remove(_ track: Track) {
        if let index = list.firstIndex(of: track) {
            list.remove(at: index)
        }
    }
}
