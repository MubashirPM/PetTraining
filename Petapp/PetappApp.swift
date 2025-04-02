//
//  PetappApp.swift
//  Petapp
//
//  Created by MUNAVAR PM on 07/02/25.
//

//
import SwiftData
import SwiftUI
import Firebase

@Model
class PetEntitys {
    var name: String
    var age: Int
    var breed: String

    init(name: String, age: Int, breed: String) {
        self.name = name
        self.age = age
        self.breed = breed
    }
}

@Model
class TrainingItem {
    var title: String
    var exercises: Int
    var duration: String

    init(title: String, exercises: Int, duration: String) {
        self.title = title
        self.exercises = exercises
        self.duration = duration
    }
}



@main
struct PetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var sharedModelContainer: ModelContainer
    @StateObject var authManager = AuthManager()
    @State private var selectedTab: AppTab = .home
    init() {
        do {
            sharedModelContainer = try ModelContainer(for: PetProfile.self, Training.self, Workout.self) //  Add Workout
        } catch {
            fatalError("❌ Failed to initialize SwiftData: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            HomeView(selectedTab: $selectedTab)
                .environmentObject(authManager)
                .modelContainer(sharedModelContainer)
                .onAppear(perform: {
                    print("authManager.isLoggedIn Home = \(authManager.isLoggedIn)")
                    authManager.isLoggedIn = true
                })
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            return true
        }
    }
}
