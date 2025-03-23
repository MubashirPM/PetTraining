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
    
    init(name: String, location: String, description: String, image: String, isFavorite: Bool) {
        self.name = name
        self.location = location
        self.description = description
        self.image = image
        self.isFavorite = isFavorite
    }
}
