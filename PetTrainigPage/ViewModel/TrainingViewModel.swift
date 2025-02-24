//
//  TrainingViewModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 21/02/25.
//
//
//import SwiftUI
//
//class TrainingViewModel: ObservableObject {
//    @Published var exercises: [TrainingExercise] = []
//    @Published var categories: [String] = ["All", "Warm Up", "Leash Training", "Agility"]
//    @Published var selectedCategory: String = "All"
//
//    init() {
//        loadExercises()
//    }
//
//    func loadExercises() {
//        exercises = [
//            TrainingExercise(title: "Warm-Up Jog", exercises: 6, duration: "18 Min", icon: "figure.walk"),
//            TrainingExercise(title: "Squat & Throw", exercises: 3, duration: "5 Min", icon: "figure.run"),
//            TrainingExercise(title: "Four-Way Run", exercises: 5, duration: "10 Min", icon: "figure.jumprope"),
//            TrainingExercise(title: "Burpees & Bounds", exercises: 5, duration: "5 Min", icon: "figure.strengthtraining.traditional"),
//            TrainingExercise(title: "Cool-Down Walk", exercises: 3, duration: "20 Min", icon: "figure.walk.circle")
//        ]
//    }
//
//    var filteredExercises: [TrainingExercise] {
//        if selectedCategory == "All" {
//            return exercises
//        } else {
//            return exercises.filter { $0.title.contains(selectedCategory) }
//        }
//    }
//
//    func selectCategory(_ category: String) {
//        selectedCategory = category
//    }
//}
// MARK: - ViewModel
//import Foundation
//import UIKit
//
//class TrainingViewModel: ObservableObject {
//    @Published var categories: [TrainingCategory] = []
//    
//    func addCategory(name: String, duration: String, difficulty: String, image: UIImage?) {
//        let newCategory = TrainingCategory(name: name, duration: duration, difficulty: difficulty, image: image)
//        categories.append(newCategory)
//    }
//}
//import SwiftData
//import Foundation
//import UIKit

//class TrainingViewModel: ObservableObject {
//    @Published var categories: [TrainingCategory] = []
//    
//    func addCategory(name: String, duration: String, difficulty: String, image: UIImage?, context: ModelContext) {
//        let newCategory = TrainingCategory(name: name, duration: duration, difficulty: difficulty, image: image)
//        context.insert(newCategory) // Save to SwiftData
//        fetchCategories(context: context) // Refresh the list
//    }
//    
//    func fetchCategories(context: ModelContext) {
//        do {
//            let request = FetchDescriptor<TrainingCategory>()
//            self.categories = try context.fetch(request) // Load from SwiftData
//        } catch {
//            print("Failed to fetch categories: \(error)")
//        }
//    }
//}
//class TrainingViewModel: ObservableObject {
//    @Published var categories: [TrainingCategory] = []
//    
//    func fetchCategories(context: ModelContext) {
//        let request = FetchDescriptor<TrainingCategory>()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Failed to fetch categories: \(error)")
//        }
//    }
//    
//    func addCategory(name: String, duration: String, difficulty: String, image: UIImage?, context: ModelContext) {
//        let newCategory = TrainingCategory(name: name, duration: duration, difficulty: difficulty)
//
//        if let image = image {
//            newCategory.imageData = image.jpegData(compressionQuality: 0.8)
//        }
//
//        context.insert(newCategory)
//
//        do {
//            try context.save()
//            fetchCategories(context: context) // Refresh list after saving
//        } catch {
//            print("Failed to save category: \(error)")
//        }
//    }
////}
//import SwiftData
//import SwiftUI
//
//class TrainingViewModel: ObservableObject {
//    @Environment(\.modelContext) private var context //  Access SwiftData context
//    @Published var categories: [TrainingCategory] = [] // ✅ Tracks category list
//
//    init() {
//        fetchCategories() // ✅ Load data when ViewModel is created
//    }
//
//    /// Fetch categories from SwiftData
//    func fetchCategories() {
//        let request = FetchDescriptor<TrainingCategory>()
//        do {
//            categories = try context.fetch(request) // ✅ Update published property
//        } catch {
//            print("Failed to fetch categories: \(error)")
//        }
//    }
//
//    /// Save a new category to SwiftData
//    func saveCategory(name: String, duration: String, difficulty: String, image: UIImage?) {
//        let newCategory = TrainingCategory(name: name, duration: duration, difficulty: difficulty)
//
//        if let image = image {
//            newCategory.imageData = image.jpegData(compressionQuality: 0.8)
//        }
//
//        context.insert(newCategory)
//
//        do {
//            try context.save() // ✅ Persist data
//            fetchCategories()  // ✅ Refresh list
//        } catch {
//            print("Failed to save category: \(error)")
//        }
//    }
//}
import SwiftData
import SwiftUI
//
//class TrainingViewModel: ObservableObject {
//    @Published var categories: [TrainingCategory] = []
//
//    private var context: ModelContext // ✅ Inject model context
//
//    init(context: ModelContext) {
//        self.context = context
//        fetchCategories()
//    }
//
//    func fetchCategories() {
//        let request = FetchDescriptor<TrainingCategory>()
//        do {
//            categories = try context.fetch(request) // ✅ Fetch categories from database
//        } catch {
//            print("Failed to fetch categories: \(error)")
//        }
//    }
//
//    func saveCategory(name: String, duration: String, difficulty: String, image: UIImage?) {
//        let newCategory = TrainingCategory(name: name, duration: duration, difficulty: difficulty)
//
//        if let image = image {
//            newCategory.imageData = image.jpegData(compressionQuality: 0.8)
//        }
//
//        context.insert(newCategory)
//
//        do {
//            try context.save()
//            fetchCategories() // ✅ Refresh list after saving
//        } catch {
//            print("Failed to save category: \(error)")
//        }
//    }
////}
//import SwiftData
//
//class TrainingViewModel: ObservableObject {
//    @Published var categories: [Category] = []  // Ensure UI updates
//
//    private var context: ModelContext
//
//    init(context: ModelContext) {
//        self.context = context
//        fetchCategories()
//    }
//
//    func fetchCategories() {
//        let descriptor = FetchDescriptor<Category>()  // SwiftData FetchDescriptor
//        do {
//            categories = try context.fetch(descriptor) // Fetch all categories
//        } catch {
//            print("Error fetching categories: \(error)")
//        }
//    }
//
//    func saveCategory(name: String, duration: String, difficulty: String, image: UIImage?) {
//        let newCategory = Category(name: name, duration: duration, difficulty: difficulty, imageData: image?.jpegData(compressionQuality: 0.8))
//
//        context.insert(newCategory) // Insert into SwiftData context
//
//        do {
//            try context.save()
//            fetchCategories() // Refresh list after saving
//        } catch {
//            print("Error saving category: \(error)")
//        }
//    }
//}
//import SwiftData
//import SwiftUI
//
//@Observable
//class TrainingViewModel {
//    private var modelContext: ModelContext
//    @Published var categories: [Category] = []
//
//    init(context: ModelContext) {
//        self.modelContext = context
//        fetchCategories() // ✅ Ensure categories are loaded initially
//    }
//
//    func fetchCategories() {
//        do {
//            let descriptor = FetchDescriptor<Category>()
//            categories = try modelContext.fetch(descriptor) // ✅ Fetch all categories
//        } catch {
//            print("Error fetching categories: \(error)")
//        }
//    }
//
//    func saveCategory(name: String, duration: String, difficulty: String, image: UIImage?) {
//        let imageData = image?.jpegData(compressionQuality: 0.8)
//        let newCategory = Category(name: name, duration: duration, difficulty: difficulty, imageData: imageData)
//
//        modelContext.insert(newCategory)
//
//        do {
//            try modelContext.save() // ✅ Save changes to SwiftData
//            fetchCategories() // ✅ Refresh categories list
//        } catch {
//            print("Error saving category: \(error)")
//        }
//    }
//}
//import SwiftUI
//import SwiftData
//
//// MARK: - ViewModel
//class TrainingViewModel: ObservableObject {
//    private var modelContext: ModelContext
//    @Published var categories: [Category] = []
//    @Published var showAddCategoryView = false
//
//    init(context: ModelContext) {
//        self.modelContext = context
//        fetchCategories()
//    }
//
//    func fetchCategories() {
//        do {
//            let descriptor = FetchDescriptor<Category>()
//            categories = try modelContext.fetch(descriptor)
//        } catch {
//            print("Error fetching categories: \(error)")
//        }
//    }
//
//    func saveCategory(name: String, duration: String, difficulty: String, image: UIImage?) {
//        let imageData = image?.jpegData(compressionQuality: 0.8)
//        let newCategory = Category(name: name, duration: duration, difficulty: difficulty, imageData: imageData)
//        modelContext.insert(newCategory)
//
//        do {
//            try modelContext.save()
//            fetchCategories()
//        } catch {
//            print("Error saving category: \(error)")
//        }
//    }
//}
import SwiftUI
import SwiftData

// MARK: - ViewModel
class TrainingViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var categories: [TrainingCategory] = []
    @Published var showAddCategoryView = false
    @Published var exercises: [TrainingExercise] = [] // ✅ Store exercises

    init(context: ModelContext) {
        self.modelContext = context
        fetchCategories()
    }

    func fetchCategories() {
        do {
            let descriptor = FetchDescriptor<TrainingCategory>()
            categories = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching categories: \(error)")
        }
    }

    func saveCategory(name: String, duration: String, difficulty: String, image: UIImage?) {
        let imageData = image?.jpegData(compressionQuality: 0.8)
        let newCategory = TrainingCategory(name: name, duration: duration, difficulty: difficulty, imageData: imageData)
        modelContext.insert(newCategory)

        do {
            try modelContext.save()
            fetchCategories()
        } catch {
            print("Error saving category: \(error)")
        }
    }

    func saveTraining(title: String, icon: String, exercises: Int, duration: String) {
        let newTraining = TrainingExercise(title: title, icon: icon, exercises: exercises, duration: duration)
        modelContext.insert(newTraining)

        do {
            try modelContext.save()
            fetchTrainings()
        } catch {
            print("Error saving training: \(error)")
        }
    }

    func fetchTrainings() {
        do {
            let descriptor = FetchDescriptor<TrainingExercise>()
            exercises = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching trainings: \(error)")
        }
    }
}
