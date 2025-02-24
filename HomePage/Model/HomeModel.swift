//
//  HomeModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 17/02/25.
//

import Foundation

struct Pet: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let description: String
    let image: String
    var isFavorite: Bool
}
