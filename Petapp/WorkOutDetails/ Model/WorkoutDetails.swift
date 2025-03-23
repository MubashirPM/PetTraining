//
//  Model.swift
//  Petapp
//
//  Created by MUNAVAR PM on 07/03/25.
//
import Foundation
import SwiftData


struct WorkoutDetails: Identifiable {
    var id = UUID()
    var name: String
    var duration: Int
    var trainingName: String //  This is missing in your preview code
    var exercises: [Exercise]
    
    init(id: UUID = UUID(), name: String, duration: Int, trainingName: String, exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.duration = duration
        self.trainingName = trainingName
        self.exercises = exercises
    }
}
