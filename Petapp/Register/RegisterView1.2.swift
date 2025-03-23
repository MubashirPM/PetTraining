//
//  RegisterView1.2.swift
//  Petapp
//
//  Created by MUNAVAR PM on 07/02/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct RegisterProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @State private var petName = ""
    @State private var location = ""
    @State private var details = ""
    @State private var energyLevel = ""
    @State private var dateOfBirth = Date()
    @State private var weight = ""
    @State private var height = ""
    @State private var category = "Dog" // ✅ Matches PetProfile model
    @State private var gender = "Male"
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var imageSelection: PhotosPickerItem? = nil

    let energyLevels = ["Low", "Medium", "High"]
    let startDate = Calendar.current.date(from: DateComponents(year: 2000))!
    let endDate = Date()
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                //  Pet Image Selection
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .clipped()
                } else {
                    Image("Dogimage") // Default pet image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .clipped()
                }

                Button(action: { isImagePickerPresented.toggle() }) {
                    Text("Select Pet Image")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width:200) // Ensure it expands properly
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                }

                .photosPicker(isPresented: $isImagePickerPresented, selection: $imageSelection)
                .onChange(of: imageSelection) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }

                //  Text Fields
                CustomTextField(icon: "person", placeholder: "Pet Name", text: $petName)
                CustomTextField(icon: "location", placeholder: "Location", text: $location)
                CustomTextField(icon: "text.justify", placeholder: "Additional Details", text: $details)

                //  Category Selection (Dog / Cat)
                HStack {
                    ForEach(["Dog", "Cat"], id: \.self) { type in
                        Button(action: { category = type }) {
                            Text(type)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background {
                                    if category == type {
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    } else {
                                        Color.gray.opacity(0.3)
                                    }
                                }
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                //  Gender Selection
                Picker("Gender", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                //  Energy Level Selection
                Menu {
                    ForEach(energyLevels, id: \.self) { level in
                        Button(action: { energyLevel = level }) {
                            Text(level)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "bolt")
                            .foregroundColor(.white)
                        
                        Text(energyLevel.isEmpty ? "Select Energy Level" : energyLevel)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
)
                    .cornerRadius(10)
                }

                //  Date Picker
                VStack(alignment: .leading) {
                    Text("Date of Birth")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    DatePicker("", selection: $dateOfBirth, in: startDate...endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                //  Weight Input
                HStack {
                    CustomTextField(icon: "scalemass", placeholder: "Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    UnitButton(title: "KG")
                }
                .padding(.horizontal)

                //  Height Input
                HStack {
                    CustomTextField(icon: "ruler", placeholder: "Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                    UnitButton(title: "CM")
                }
                .padding(.horizontal)

                //  Save Profile Button
                Button(action: saveProfile) {
                    Text("Save Profile")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("Register Pet")
            .navigationBarBackButtonHidden(true) // Hide default back button
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss() // Custom back button action
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") //  Custom back icon
                                .font(.system(size: 18, weight: .semibold))
                            Text("Back")
                        }
                        .foregroundColor(.purple) //  Purple back button color
                    }
                }
            }
        }
    }


    func saveProfile() {
        guard let weightValue = Double(weight), let heightValue = Double(height) else {
            print("❌ Error: Invalid weight or height input")
            return
        }

        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        let newProfile = PetProfile(
            petName: petName,
            location: location,
            details: details,
            energyLevel: energyLevel,
            dateOfBirth: dateOfBirth,
            weight: weightValue,
            height: heightValue,
            category: category,
            gender: gender,
            imageData: imageData
        )

        print(" Attempting to insert pet: \(newProfile.petName)") // Debug Print

        modelContext.insert(newProfile) //  Insert pet into SwiftData

        do {
            try modelContext.save() //  Force SwiftData to save
            print(" Pet saved successfully: \(newProfile.petName)")
        } catch {
            print(" Failed to save pet: \(error.localizedDescription)")
        }

        presentationMode.wrappedValue.dismiss() //  Close the view
    }

}

// MARK: - Unit Button
struct UnitButton: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .leading,
                endPoint: .trailing
            )
)
            .cornerRadius(10)
    }
}

// MARK: - Preview
struct RegisterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterProfileView()
        }
    }
}
