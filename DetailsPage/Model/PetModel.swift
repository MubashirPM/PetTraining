//
//  PetModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 21/02/25.
//

import Foundation
import SwiftUI

struct Animal: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let breed: String
    let gender: String
    let description: String
    let image: String
    let gallery: [String]
}

import Foundation
import SwiftUI

extension PetProfile {
    func toAnimal() -> Animal {
        return Animal(
            name: self.petName,
            location: self.location,
            breed: "Unknown",          // ❓ No breed in PetProfile, using default value
            gender: self.gender,
            description: self.details ?? "No description available.",
            image: convertImageToBase64(), // ✅ Convert imageData to a Base64 String
            gallery: [] // ❓ No gallery in PetProfile, using empty array
        )
    }
    
    private func convertImageToBase64() -> String {
        guard let imageData = self.imageData else { return "default_pet" } // Use default if no image
        return imageData.base64EncodedString()
    }
}
