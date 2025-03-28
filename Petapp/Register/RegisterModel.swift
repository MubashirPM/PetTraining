//
//  RegisterModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 19/02/25.
//
//

import SwiftData
import Foundation

@Model
class PetProfile {
    var petName: String
    var location: String
    var details: String
    var energyLevel: String
    var dateOfBirth: Date
    var weight: Double
    var height: Double
    var category: String
    var gender: String
    var imageData: Data?
    var isFavorite: Bool 

    init(petName: String, location: String, details: String, energyLevel: String, dateOfBirth: Date, weight: Double, height: Double, category: String, gender: String, imageData: Data?, isFavorite: Bool = false) {
        self.petName = petName
        self.location = location
        self.details = details
        self.energyLevel = energyLevel
        self.dateOfBirth = dateOfBirth
        self.weight = weight
        self.height = height
        self.category = category
        self.gender = gender
        self.imageData = imageData
        self.isFavorite = isFavorite
    }
}
