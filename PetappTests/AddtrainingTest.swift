//
//  AddtrainingTest.swift
//  PetappTests
//
//  Created by MUNAVAR PM on 22/04/25.
//

import XCTest
import SwiftData
import UIKit
@testable import Petapp

//  Place this function outside the test class
func addTraining(context: ModelContext, name: String, duration: Int, image: UIImage?) {
    print(" DEBUG: addTraining() function started")
    print(" DEBUG: Raw Name: '\(name)', Raw Duration: \(duration)")

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
}

//  Your test class follows below
@MainActor
final class TrainingTests: XCTestCase {
    var context: ModelContext!
    var container: ModelContainer!
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Training.self, configurations: config)
        context = container.mainContext
    }
    
    override func tearDown() async throws {
        context = nil
        container = nil
    }
    
    func testAddValidTraining() throws {
        let name = "Morning Walk"
        let duration = 30
        let testImage = UIImage(systemName: "pawprint.fill")

        addTraining(context: context, name: name, duration: duration, image: testImage)
        
        let descriptor = FetchDescriptor<Training>(predicate: #Predicate { $0.name == name })
        let results = try context.fetch(descriptor)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, name)
        XCTAssertEqual(results.first?.duration, duration)
        XCTAssertNotNil(results.first?.imageData)
    }
    
    func testAddTrainingWithoutImage() throws {
        let name = "Evening Play"
        let duration = 20

        addTraining(context: context, name: name, duration: duration, image: nil)

        let descriptor = FetchDescriptor<Training>(predicate: #Predicate { $0.name == name })
        let results = try context.fetch(descriptor)

        XCTAssertEqual(results.count, 1)
        XCTAssertNil(results.first?.imageData)
    }
    
    func testEmptyNameNotSaved() throws {
        addTraining(context: context, name: "   ", duration: 15, image: nil)

        let allTrainings = try context.fetch(FetchDescriptor<Training>())
        XCTAssertTrue(allTrainings.isEmpty)
    }
    
    func testInvalidDurationsNotSaved() throws {
        let testCases = [
            (name: "Zero Duration", duration: 0),
            (name: "Negative Duration", duration: -5),
            (name: "Excessive Duration", duration: 10000)
        ]

        for testCase in testCases {
            addTraining(context: context, name: testCase.name, duration: testCase.duration, image: nil)

            let descriptor = FetchDescriptor<Training>(predicate: #Predicate { [name] in $0.name == name })
            let results = try context.fetch(descriptor)
            XCTAssertTrue(results.isEmpty, "Should not save \(testCase.name)")
        }
    }
    func testAddTrainingPerformance() throws {
        measure {
            addTraining(context: context, name: "Performance Test", duration: 5, image: nil)
        }
    }
}
