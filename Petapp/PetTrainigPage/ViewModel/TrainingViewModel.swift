//
//  TrainingViewModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 02/03/25.
//

import SwiftUI
import SwiftData
class TrainViewModel: ObservableObject {
    @Published var trainings: [Training] = []
    @MainActor
    func addTraining(context: ModelContext, name: String, duration: Int, image: UIImage?) {
        print(" DEBUG: addTraining() function started")
        print(" DEBUG: Raw Name: '\(name)', Raw Duration: \(duration)")

        // Input validation - Print potential issues
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print(" DEBUG: Name is empty after trimming spaces")
        }
        if duration <= 0 {
            print(" DEBUG: Duration is invalid (<= 0)")
        }

        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, duration > 0 else {
            print(" DEBUG: Invalid input - Name or Duration missing")
            return
        }

        let imageData = image?.jpegData(compressionQuality: 0.8)
        let newTraining = Training(name: name, duration: duration, imageData: imageData)

        print(" DEBUG: Attempting to insert training: \(newTraining.name), Duration: \(newTraining.duration) mins")

        context.insert(newTraining)

        do {
            try context.save()
            print(" DEBUG: Training Saved Successfully: \(newTraining.name), Duration: \(newTraining.duration) mins")
        } catch {
            print(" DEBUG: Failed to save training: \(error.localizedDescription)")
        }

        fetchTrainings(context: context)
    }


    @MainActor
    func fetchTrainings(context: ModelContext) {
        print(" DEBUG: Fetching Trainings...")

        let descriptor = FetchDescriptor<Training>()
        if let fetchedData = try? context.fetch(descriptor) {
            DispatchQueue.main.async {
                self.trainings = fetchedData
                print(" Trainings Count: \(self.trainings.count)") //  Debugging print
            }
        } else {
            print(" DEBUG: Failed to fetch trainings")
        }
    }
}
