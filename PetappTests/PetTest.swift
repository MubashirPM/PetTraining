//
//  PetTest.swift
//  PetappTests
//
//  Created by MUNAVAR PM on 22/04/25.
//

//import XCTest
//@testable deletePet

//final class PetTest: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

//}
import SwiftUI
import XCTest
import SwiftData
@testable import Petapp

@MainActor
final class PetProfileTests: XCTestCase {
    
    var modelContext: ModelContext!
    var container: ModelContainer!

    override func setUpWithError()  throws {
        // Set up in-memory model container for testing
        container = try ModelContainer(for: PetProfile.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        modelContext = container.mainContext
    }
   
    @MainActor
    func testDeletePet() throws {
        // 1. Create an empty PetProfile and assign values
        let pet = PetProfile(
            petName: "Browny",
            location: "New York",
            details: "Friendly Labrador",
            energyLevel: "High",
            dateOfBirth: Date(),
            weight: 30.0,
            height: 60.0,
            category: "Dog",
            gender: "Male",
            imageData: nil, // Optional data for the image
            isFavorite: false
        )

        // 2. Insert into context
        modelContext.insert(pet)
        try modelContext.save()

        // 3. Verify it exists
        var pets = try modelContext.fetch(FetchDescriptor<PetProfile>())
        XCTAssertTrue(pets.contains(pet), "Pet should exist before deletion")

        // 4. Delete it
        withAnimation {
            modelContext.delete(pet)
            try? modelContext.save()
        }

        // 5. Verify it’s gone
        pets = try modelContext.fetch(FetchDescriptor<PetProfile>())
        XCTAssertFalse(pets.contains(pet), "Pet should be deleted")
    }
}
