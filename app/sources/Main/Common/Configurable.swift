//
//  Configurable.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

protocol Configurable {
    var smallIcon: String { get }
    var bigIcon: String { get }
    var title: String { get }
    var subtitle: String { get }
    var previewUrl: String { get }
}
