//
//  PetappApp.swift
//  Petapp
//
//  Created by MUNAVAR PM on 07/02/25.
//
//

import SwiftUI
import Firebase
import SwiftData

//@main
//struct PetApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    
//    var sharedModelContainer: ModelContainer = {
//        do {
//            let schema = Schema([PetProfile.self])
//            let container = try ModelContainer(for: schema)
//            return container
//        } catch {
//            fatalError("❌ Failed to initialize SwiftData: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            HomeView()
//                .modelContainer(sharedModelContainer) // Inject SwiftData container
//        }
//    }
//}
@main
struct PetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var sharedModelContainer: ModelContainer = {
        do {
            let schema = Schema([PetProfile.self, TrainingCategory.self]) // ✅ Add TrainingCategory
            let container = try ModelContainer(for: schema)
            return container
        } catch {
            fatalError("❌ Failed to initialize SwiftData: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(sharedModelContainer) // ✅ Inject SwiftData container
        }
    }
}

// MARK: - Firebase Initialization
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

