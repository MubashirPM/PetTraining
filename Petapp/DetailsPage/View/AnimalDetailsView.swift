//
//  AnimalDetailsView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 02/03/25.
//
//

import SwiftUI
import SwiftUI

struct AnimalDetailView: View {
    let animal: Animal
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 🔹 Pet Image (Fixed Corner Radius & Padding)
                if let uiImage = loadImage(animal.image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill() //  Ensures it fills the frame properly
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20)) //  Corner radius applied correctly
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1) //  Optional subtle border
                        )
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5) //  Shadow for depth
                        .padding(.horizontal, 20) //  Padding to prevent edge clipping
                } else {
                    Image("default_pet")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                        .padding(.horizontal, 20)
                }

                //  Pet Name & Location
                VStack(spacing: 5) {
                    Text(animal.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(animal.location)
                        .font(.subheadline)
                        .foregroundColor(.purple)
                }

                // 🔹 Tags Section
                HStack(spacing: 10) {
                    TagView(text: animal.breed, icon: "pawprint.fill", color: .yellow)
                    TagView(text: animal.gender, icon: "person.fill", color: .pink)
                }
                .padding(.top, 5)

                //  Pet Description
                Text(animal.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)

                //  Training Button (Fixed Padding)
                NavigationLink(destination: TrainView()) {
                    Text("Training")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 5)
                        .padding(.horizontal, 40)
                        .padding(.top, 15)
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle(animal.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .tint(.purple)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Back")
                    }
                    .foregroundColor(.purple)
                }
            }
        }
    }
    
    // Function to Load Image (Handles both Base64 and Asset Images)
    private func loadImage(_ imageString: String) -> UIImage? {
        if let assetImage = UIImage(named: imageString) {
            return assetImage
        }
        if let imageData = Data(base64Encoded: imageString),
           let uiImage = UIImage(data: imageData) {
            return uiImage
        }
        return nil
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
    let exercise: TrainingExercise  //  Now recognized properly

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

// MARK: - Preview
struct TrainingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingDetailView(exercise: TrainingExercise(
            title: "Agility Training",
            icon: "hare.fill",
            exercises: 5,
            duration: "30 mins"
        ))
    }
}
