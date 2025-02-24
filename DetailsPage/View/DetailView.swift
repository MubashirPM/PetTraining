//
//  DetailView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 21/02/25.
//
//
//import SwiftUI
//
//struct AnimalDetailView: View {
//    let animal: Animal  // ✅ Updated to use Animal model
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                // 🔹 Pet Image (Handles both asset images and Base64-encoded images)
//                if let uiImage = loadImage(animal.image) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 250)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .padding(.horizontal)
//                } else {
//                    Image("default_pet")  // ✅ Use a default image if decoding fails
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 250)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .padding(.horizontal)
//                }
//
//                // 🔹 Pet Name & Location
//                Text(animal.name)
//                    .font(.title)
//                    .fontWeight(.bold)
//
//                Text(animal.location)
//                    .font(.subheadline)
//                    .foregroundColor(.purple)
//
//                // 🔹 Tags Section
//                HStack {
//                    TagView(text: animal.breed, icon: "pawprint.fill", color: .yellow)
//                    TagView(text: animal.gender, icon: "person.fill", color: .pink)
//                }
//                .padding(.top, 5)
//
//                // 🔹 Pet Description
//                Text(animal.description)
//                    .font(.body)
//                    .foregroundColor(.gray)
//                    .padding()
//                    .multilineTextAlignment(.center)
//
//                // 🔹 Training Button
//                NavigationLink(destination: TrainingView(animal: animal, modelContext: modelContext)) {
//                    Text("Training")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//                        .padding(.horizontal, 30)
//                }
//                .padding(.top, 10)
//
//                Spacer()
//            }
//        }
//        .navigationTitle(animal.name)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//    
//    // ✅ Function to Load Image (Handles both Base64 and Asset Images)
//    private func loadImage(_ imageString: String) -> UIImage? {
//        if let assetImage = UIImage(named: imageString) {
//            return assetImage // ✅ Load from assets if available
//        }
//        if let imageData = Data(base64Encoded: imageString),
//           let uiImage = UIImage(data: imageData) {
//            return uiImage // ✅ Decode Base64 if provided
//        }
//        return nil // ❌ Return nil if no valid image found
//    }
//}
//
//// MARK: - Tag View
//struct TagView: View {
//    let text: String
//    let icon: String
//    let color: Color
//
//    var body: some View {
//        HStack {
//            if !icon.isEmpty {
//                Image(systemName: icon)
//            }
//            Text(text)
//        }
//        .font(.caption)
//        .padding(.horizontal, 10)
//        .padding(.vertical, 5)
//        .background(color.opacity(0.2))
//        .clipShape(Capsule())
//    }
//}
//
//// MARK: - Training Detail View
//struct TrainingDetailView: View {
//    let exercise: TrainingExercise
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Image(systemName: exercise.icon)
//                .resizable()
//                .frame(width: 80, height: 80)
//                .foregroundColor(.blue)
//            
//            Text(exercise.title)
//                .font(.largeTitle)
//                .bold()
//
//            Text("\(exercise.exercises) Exercises • \(exercise.duration)")
//                .font(.headline)
//                .foregroundColor(.gray)
//
//            Spacer()
//        }
//        .padding()
//        .navigationTitle(exercise.title)
//    }
//}
import SwiftUI

struct AnimalDetailView: View {
    let animal: Animal
    @Environment(\.modelContext) private var modelContext  //  Environment property wrapper for model context

    var body: some View {
        ScrollView {
            VStack {
                // 🔹 Pet Image (Handles both asset images and Base64-encoded images)
                if let uiImage = loadImage(animal.image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                } else {
                    Image("default_pet")  //  Use a default image if decoding fails
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                }

                // 🔹 Pet Name & Location
                Text(animal.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text(animal.location)
                    .font(.subheadline)
                    .foregroundColor(.purple)

                // 🔹 Tags Section
                HStack {
                    TagView(text: animal.breed, icon: "pawprint.fill", color: .yellow)
                    TagView(text: animal.gender, icon: "person.fill", color: .pink)
                }
                .padding(.top, 5)

                // 🔹 Pet Description
                Text(animal.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                    .multilineTextAlignment(.center)

                // 🔹 Training Button
                NavigationLink(destination: TrainingView(animal: animal, modelContext: modelContext)) {
                    Text("Training")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.horizontal, 30)
                }
                .padding(.top, 10)

                Spacer()
            }
        }
        .navigationTitle(animal.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //  Function to Load Image (Handles both Base64 and Asset Images)
    private func loadImage(_ imageString: String) -> UIImage? {
        if let assetImage = UIImage(named: imageString) {
            return assetImage //  Load from assets if available
        }
        if let imageData = Data(base64Encoded: imageString),
           let uiImage = UIImage(data: imageData) {
            return uiImage //  Decode Base64 if provided
        }
        return nil //  Return nil if no valid image found
    }
}

// MARK: - Tag View
struct TagView: View {
    let text: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            if !icon.isEmpty {
                Image(systemName: icon)
            }
            Text(text)
        }
        .font(.caption)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.2))
        .clipShape(Capsule())
    }
}

// MARK: - Training Detail View
struct TrainingDetailView: View {
    let exercise: TrainingExercise

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: exercise.icon)
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            Text(exercise.title)
                .font(.largeTitle)
                .bold()

            Text("\(exercise.exercises) Exercises • \(exercise.duration)")
                .font(.headline)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationTitle(exercise.title)
    }
}
