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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @State private var petName = ""
    @State private var location = ""
    @State private var details = ""
    @State private var energyLevel = ""
    @State private var dateOfBirth = Date()
    @State private var weight = ""
    @State private var height = ""
    @State private var category = "Dog" // ✅ FIX: Ensure it matches `PetProfile`
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
                // Pet Image Selection
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .clipped()
                } else {
                    Image("Dogimage")
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
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.purple]), startPoint: .leading, endPoint: .trailing))
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

                // Text Fields
                CustomTextField2(icon: "person", placeholder: "Pet Name", text: $petName)
                CustomTextField2(icon: "location", placeholder: "Location", text: $location)
                CustomTextField2(icon: "text.justify", placeholder: "Additional Details", text: $details)

                // Pet Type Selection (Dog / Cat)
                HStack {
                    ForEach(["Dog", "Cat"], id: \.self) { type in
                        Button(action: { category = type }) {
                            Text(type)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(category == type ? Color.purple : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }

                // Gender Selection
                Picker("Gender", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Energy Level Selection
                Menu {
                    ForEach(energyLevels, id: \.self) { level in
                        Button(action: {
                            energyLevel = level
                        }) {
                            Text(level)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "bolt")
                        Text(energyLevel.isEmpty ? "Select Energy Level" : energyLevel)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }

                // Date Picker
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

                // Weight Input
                HStack {
                    CustomTextField2(icon: "scalemass", placeholder: "Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    UnitButton(title: "KG")
                }
                .padding(.horizontal)

                // Height Input
                HStack {
                    CustomTextField2(icon: "ruler", placeholder: "Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                    UnitButton(title: "CM")
                }
                .padding(.horizontal)

                // Save Profile Button
                Button(action: saveProfile) {
                    Text("Save Profile")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("Register Pet")
            .navigationBarBackButtonHidden(false)
        }
    }

    // Save Profile Function
    func saveProfile() {
        guard let weightValue = Double(weight), let heightValue = Double(height) else { return }
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        let newProfile = PetProfile(
            petName: petName,
            location: location,
            details: details,
            energyLevel: energyLevel,
            dateOfBirth: dateOfBirth,
            weight: weightValue,
            height: heightValue,
            category: category, // ✅ FIX: Corrected category
            gender: gender,
            imageData: imageData
        )
        
        modelContext.insert(newProfile)
        presentationMode.wrappedValue.dismiss()
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
            .background(Color.purple)
            .cornerRadius(10)
    }
}

// Preview
struct RegisterProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RegisterProfileView()
        }
    }
}
