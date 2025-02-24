//
//  TrainingExercise.swift
//  Petapp
//
//  Created by MUNAVAR PM on 21/02/25.
//

//import Foundation
//
//struct TrainingExercise: Identifiable {
//    let id = UUID()
//    let title: String
//    let exercises: Int
//    let duration: String
//    let icon: String
//}
//
//import Foundation
import SwiftUI
import PhotosUI  

//struct TrainingCategory: Identifiable {
//    let id = UUID()
//    var name: String
//    var duration: String
//    var difficulty: String
//    var image: UIImage?
//}
//struct TrainingExercise: Identifiable {
//    let id = UUID()
//    let title: String
//    let exercises: Int
//    let duration: String
//    let icon: String
//}
//import SwiftData
//import SwiftUI
//
//@Model
//class TrainingCategory {
//    var id: UUID
//    var name: String
//    var duration: String
//    var difficulty: String
//    var imageData: Data?
//
//    init(name: String, duration: String, difficulty: String, image: UIImage?) {
//        self.id = UUID()
//        self.name = name
//        self.duration = duration
//        self.difficulty = difficulty
//        self.imageData = image?.jpegData(compressionQuality: 0.8) // Convert image to Data
//    }
//}
//struct TrainingExercise: Identifiable {
//    let id = UUID()
//    let title: String
//    let icon: String
//    let exercises: Int
//    let duration: String
//}
//import SwiftData
//
//@Model
//class TrainingCategory {
//    var id: UUID
//    var name: String
//    var duration: String
//    var difficulty: String
//    var imageData: Data?
//    
//    init(name: String, duration: String, difficulty: String, imageData: Data? = nil) {
//        self.id = UUID()
//        self.name = name
//        self.duration = duration
//        self.difficulty = difficulty
//        self.imageData = imageData
//    }
//}
//
//import SwiftData
//
//@Model  // ✅ No need to explicitly conform to PersistentModel
//class Category {
//    var name: String
//    var duration: String
//    var difficulty: String
//    var imageData: Data?
//
//    init(name: String, duration: String, difficulty: String, imageData: Data?) {
//        self.name = name
//        self.duration = duration
//        self.difficulty = difficulty
//        self.imageData = imageData
//    }
//}
import SwiftData

@Model
class TrainingExercise {
    var id: UUID
    var title: String
    var icon: String
    var exercises: Int
    var duration: String

    init(title: String, icon: String, exercises: Int, duration: String) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.exercises = exercises
        self.duration = duration
    }
}
@Model
class TrainingCategory {
    var id: UUID
    var name: String
    var duration: String
    var difficulty: String
    var imageData: Data?
    var exercises: [TrainingExercise] = [] // ✅ Added relation to TrainingExercise

    init(name: String, duration: String, difficulty: String, imageData: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.duration = duration
        self.difficulty = difficulty
        self.imageData = imageData
    }
}
