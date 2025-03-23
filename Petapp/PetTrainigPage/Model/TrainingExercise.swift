//
//  TrainingExercise.swift
//  Petapp
//
//  Created by MUNAVAR PM on 21/02/25.
//
//

import SwiftData
import SwiftUI

@Model
class Training {
    var id: UUID = UUID() // Explicit ID (not required)
    var name: String
    var duration: Int
    var imageData: Data?

    init(name: String, duration: Int, imageData: Data?) {
        self.name = name
        self.duration = duration
        self.imageData = imageData
    }
}
