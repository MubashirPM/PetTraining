//
//  Model.swift
//  Petapp
//
//  Created by MUNAVAR PM on 04/03/25.
//

import SwiftData
import Foundation

@Model
class Exercise {
    let id: UUID = UUID()  // If needed
    var name: String
    var reps: Int
    var workout: Workout?  // Relationship back to Workout

    init(name: String, reps: Int, workout: Workout? = nil) {
        self.name = name
        self.reps = reps
        self.workout = workout
    }
}
@Model
class Workout: Identifiable {  //  Make Workout Identifiable
    var id: UUID = UUID()
    var name: String
    var duration: Int
    var trainingName: String
    @Relationship(deleteRule: .cascade) var exercises: [Exercise] = []

    init(name: String, duration: Int, trainingName: String, exercises: [Exercise] = []) {
        self.name = name
        self.duration = duration
        self.trainingName = trainingName
        self.exercises = exercises
    }
}
