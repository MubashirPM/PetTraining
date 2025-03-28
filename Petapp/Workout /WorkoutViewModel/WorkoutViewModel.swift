//
//  WorkoutViewModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 04/03/25.
//

import Foundation
import SwiftData
import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []  // Published property to update UI

    func fetchWorkouts(trainingName: String, context: ModelContext) {
        do {
            print("🔍 Fetching workouts for trainingName: \(trainingName)")

            let allWorkouts = try context.fetch(FetchDescriptor<Workout>())
            print(
                "🗂️ All stored workouts: \(allWorkouts.map { $0.trainingName })"
            )

            var descriptor = FetchDescriptor<Workout>(
                predicate: #Predicate { workout in
                    workout.trainingName == trainingName
                },
                sortBy: [SortDescriptor(
                    \Workout.name
                )] // Sorting for consistency
            )
            let fetchedWorkouts = try context.fetch(descriptor)

            DispatchQueue.main.async {
                self.workouts = fetchedWorkouts  //  Update UI with new data
            }

            print(
                " fetchWorkouts() called – Found \(fetchedWorkouts.count) workouts for training: \(trainingName)"
            )
        } catch {
            print(" ERROR: Fetching workouts failed: \(error)")
        }
    }

    func addWorkout(
        context: ModelContext,
        name: String,
        duration: Int,
        exercises: [Exercise],
        trainingName: String
    ) {
        print(" Attempting to save workout: \(name), Training: \(trainingName)")

        let newWorkout = Workout(
            name: name,
            duration: duration,
            trainingName: trainingName
        )
        context.insert(newWorkout)

        do {
            try context.save()
            print(" Workout successfully saved!")

            let allWorkouts = try context.fetch(FetchDescriptor<Workout>())
            print(" All workouts after saving: \(allWorkouts.map { $0.name })")

            self.fetchWorkouts(trainingName: trainingName, context: context)
        } catch {
            print(" Failed to save workout: \(error)")
        }
    }

    //  Move deleteWorkout() OUTSIDE of addWorkout()
    func deleteWorkout(_ workout: Workout, context: ModelContext) {
        context.delete(workout)

        do {
            try context.save()
            print(" Deleted workout: \(workout.name)")

            fetchWorkouts(trainingName: workout.trainingName, context: context)
        } catch {
            print(" ERROR: Failed to delete workout: \(error)")
        }
    }
}
