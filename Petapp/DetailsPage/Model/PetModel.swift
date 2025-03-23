//
//  PetModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 21/02/25.
//
import Foundation
import SwiftUI

//
//  Updated Animal Model with `category`
struct PetEntity: Identifiable {  //  Renamed from PetProfile to PetEntity
    let id: UUID
    let petName: String
    let location: String
    let gender: String
    let details: String?
    let imageData: Data?
    let category: String?  //  Ensure category exists
    let breed: String?     //  Ensure breed exists
}

extension PetProfile {
    func toAnimal() -> Animal {
        return Animal(
            name: self.petName,
            location: self.location,
            breed: "Unknown",  //  Removed self.breed, using "Unknown"
            gender: self.gender,
            description: self.details ?? "No description available.",
            image: convertImageToBase64(),
            gallery: [],
            category: self.category ?? "Unknown" //  Ensure category is passed correctly
        )
    }
    
    private func convertImageToBase64() -> String {
        guard let imageData = self.imageData else { return "default_pet" } // Use default if no image
        return imageData.base64EncodedString()
    }
}
struct Animal: Identifiable {
    var id = UUID()
    var name: String
    var location: String
    var breed: String
    var gender: String
    var description: String
    var image: String // Can be Base64 or Asset name
    var gallery: [String] // ✅ Added this
    var category: String  // ✅ Added this
}

struct TrainingExercise {
    let title: String
    let icon: String
    let exercises: Int
    let duration: String
}


//import Foundation
//import SwiftUI
//
//// ✅ Improved PetEntity with Default Values
//struct PetEntity: Identifiable {
//    let id: UUID
//    let petName: String
//    let location: String
//    let gender: String
//    let details: String?
//    let imageData: Data?
//    let category: String
//    let breed: String
//
//    init(
//        id: UUID = UUID(),
//        petName: String,
//        location: String,
//        gender: String,
//        details: String? = nil,
//        imageData: Data? = nil,
//        category: String = "Unknown",
//        breed: String = "Unknown"
//    ) {
//        self.id = id
//        self.petName = petName
//        self.location = location
//        self.gender = gender
//        self.details = details
//        self.imageData = imageData
//        self.category = category
//        self.breed = breed
//    }
//}
//
//// ✅ Ensure PetProfile Exists Before Extending It
//struct PetProfilestart {
//    let petName: String
//    let location: String
//    let gender: String
//    let details: String?
//    let imageData: Data?
//    let category: String?
//}
//
//// ✅ Improved Conversion from PetProfile to Animal
//extension PetProfilestart {
//    func toAnimal() -> Animal {
//        return Animal(
//            name: self.petName,
//            location: self.location,
//            breed: "Unknown",  // Using "Unknown" if breed isn't available
//            gender: self.gender,
//            description: self.details ?? "No description available.",
//            image: convertImageToBase64(),  // Ensures image is properly converted
//            gallery: [],
//            category: self.category ?? "Unknown"
//        )
//    }
//
//    private func convertImageToBase64() -> String {
//        guard let imageData = self.imageData else { return "default_pet" } // Use default image placeholder
//        return imageData.base64EncodedString()
//    }
//}
//
//// ✅ Improved Animal Model
//struct Animal: Identifiable {
//    let id = UUID()
//    let name: String
//    let location: String
//    let breed: String
//    let gender: String
//    let description: String
//    let image: String
//    let gallery: [String]
//    let category: String
//}
