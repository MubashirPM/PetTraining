//
//  info.swift
//  Petapp
//
//  Created by MUNAVAR PM on 12/02/25.
//

import SwiftUI

struct PetDetailView: View {
    let pet: PetProfile  // Passed pet object

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Display Pet Image
                if let imageData = pet.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                // Pet Details
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name: \(pet.petName)")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Location: \(pet.location)")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("Gender: \(pet.gender)")
                        .font(.headline)
                        .foregroundColor(.blue)

                    Text("Energy Level: \(pet.energyLevel)")
                        .font(.headline)
                        .foregroundColor(.orange)

                    Text("Date of Birth: \(pet.dateOfBirth.formatted(date: .abbreviated, time: .omitted))")
                        .font(.headline)
                        .foregroundColor(.green)

                    Text("Weight: \(pet.weight, specifier: "%.1f") KG")
                        .font(.headline)

                    Text("Height: \(pet.height, specifier: "%.1f") CM")
                        .font(.headline)

                    Text("Details: \(pet.details)")
                        .font(.body)
                        .padding(.top, 5)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Pet Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
