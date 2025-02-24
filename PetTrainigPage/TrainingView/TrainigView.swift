//
//  TrainigView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 21/02/25.
//
import SwiftUI
import UIKit
import SwiftData

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
import SwiftUI
import SwiftData

// MARK: - Training View
struct TrainingView: View {
    let animal: Animal
    @StateObject private var viewModel: TrainingViewModel

    init(animal: Animal, modelContext: ModelContext) {
        self.animal = animal
        _viewModel = StateObject(wrappedValue: TrainingViewModel(context: modelContext))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                List(viewModel.categories) { category in
                    HStack {
                        if let imageData = category.imageData, let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.headline)
                            Text("Duration: \(category.duration) | \(category.difficulty)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }

                List(viewModel.exercises) { training in
                    HStack {
                        Image(systemName: training.icon)
                        VStack(alignment: .leading) {
                            Text(training.title)
                                .font(.headline)
                            Text("Exercises: \(training.exercises) | Duration: \(training.duration)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchCategories()
                viewModel.fetchTrainings()
            }
            .navigationTitle("Training Categories")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    viewModel.showAddCategoryView.toggle()
                }) {
                    Image(systemName: "plus")
                }
            })
            .sheet(isPresented: $viewModel.showAddCategoryView) {
                AddCategoryView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Add Category View
struct AddCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TrainingViewModel

    @State private var categoryName = ""
    @State private var workoutTime = ""
    @State private var selectedDifficulty = "Medium"
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    let difficultyLevels = ["High", "Medium", "Low"]

    var body: some View {
        VStack(spacing: 15) {
            Text("Add Category")
                .font(.title2)
                .bold()

            Button(action: { showImagePicker = true }) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(Text("Add Image").foregroundColor(.gray))
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }

            TextField("Category Name", text: $categoryName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Workout Time", text: $workoutTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Picker("Select Difficulty", selection: $selectedDifficulty) {
                ForEach(difficultyLevels, id: \.self) { level in
                    Text(level)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button(action: saveCategory) {
                Text("Save")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .padding()
    }

    private func saveCategory() {
        viewModel.saveCategory(name: categoryName, duration: workoutTime, difficulty: selectedDifficulty, image: selectedImage)
        dismiss()
    }
}
