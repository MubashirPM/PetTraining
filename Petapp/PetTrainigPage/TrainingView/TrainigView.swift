//
////  TrainigView.swift
////  Petapp
////
////  Created by MUNAVAR PM on 21/02/25.
//

import PhotosUI
import SwiftUI
import SwiftData

struct TrainView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = TrainViewModel()
    @State private var showAddSheet = false
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .leading) { //  Align content properly
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [Color.purple, Color.blue]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 140) // Reduced height
                        .padding(.horizontal,10)
                    HStack {
                        VStack(
                            alignment: .leading,
                            spacing: 10
                        ) { //  Increased spacing
                            Text("Start Strong and Set Training Goals")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                ) //  Prevents text from overflowing

                            Button(action: {
                                print("Start Training Tapped")
                            }) {
                                Text("Start Training")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical,8)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                            .padding(
                                .bottom,
                                15
                            ) //  Space between button and bottom edge
                        }
                        .padding(
                            .leading,
                            20
                        ) //  More padding for better spacing
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer() //  Ensures the image is not pushed too far left

                        Image(systemName: "pawprint.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                            .padding(
                                .trailing,
                                20
                            ) //  Ensures spacing from the right
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 140,
                        alignment: .center
                    ) // Ensures full width usage
                }
                .padding(.top, 15)

                Spacer() 

                
                if viewModel.trainings.isEmpty {
                    EmptyTrainingView()
                } else {
                    TrainingListView(
                        viewModel: viewModel,
                        deleteTrainingAt: deleteTrainingAt
                    )
                }
            }
            .onAppear {
                viewModel.fetchTrainings(context: context)
            }
            // navigation and toolbar configuration
            
            .navigationTitle("Trainings")
            .navigationBarBackButtonHidden(
                true
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { // Custom Back Button
                    Button(action: {
                        // Go back to previous screen
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Back")
                        }
                        .foregroundColor(.purple) //  Custom Purple Back Button
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.purple)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddTrainingView(viewModel: viewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
//        .navigationBarHidden(true)
    }


    
    // MARK: - Delete Training
    private func deleteTraining(_ training: Training) {
        withAnimation {
            context.delete(training)
            try? context.save()
            viewModel.fetchTrainings(context: context)
        }
    }

    private func deleteTrainingAt(_ indexSet: IndexSet) { // Deletes multiple training records at specified indices in the list.
        for index in indexSet {
            let training = viewModel.trainings[index]
            deleteTraining(training)
        }
    }
}


//responsible for displaying a list of training sessions and providing options to delete or edit them
struct TrainingListView: View {
    @ObservedObject var viewModel: TrainViewModel
    var deleteTrainingAt: (IndexSet) -> Void
    @State private var selectedTraining: Training? // For editing
    @State private var showEditSheet = false // Control edit modal

    var body: some View {
        List {
            ForEach(viewModel.trainings, id: \.id) { training in
                NavigationLink(
                    destination: WorkoutView(
                        viewModel: WorkoutViewModel(),
                        trainingName: training.name
                    )
                ) {
                    TrainingRow(training: training)
                }
                .swipeActions {
                    // Delete Button
                    Button(role: .destructive) {
                        if let index = viewModel.trainings.firstIndex(
                            where: { $0.id == training.id
                            }) {
                            deleteTrainingAt(IndexSet(integer: index))
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    // Edit Button
                    Button {
                        selectedTraining = training
                        showEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
            .onDelete { indexSet in
                deleteTrainingAt(indexSet)
            }
        }
        .listStyle(.insetGrouped)
        .sheet(item: $selectedTraining) { training in
            EditTrainingView(training: training, viewModel: viewModel)
        }
    }
}

// responsible for displaying a single training session in a list
struct TrainingRow: View {
    let training: Training
    
    var body: some View {
        HStack(spacing: 15) {
            TrainingImageView(imageData: training.imageData)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(training.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Duration: \(training.duration) mins")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}
struct TrainingImageView: View {
    let imageData: Data?
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 3)
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray.opacity(0.7))
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Empty Training View
struct EmptyTrainingView: View {
    var body: some View {
        VStack {
            Image(systemName: "list.bullet.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.7))
                .padding(.bottom, 10)
            
            Text("No Trainings Available")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            Text("Tap '+' to add a new training session.")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}



struct EditTrainingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var name: String
    @State private var duration: String
    var training: Training
    var viewModel: TrainViewModel

    init(training: Training, viewModel: TrainViewModel) {
        self.training = training
        self.viewModel = viewModel
        _name = State(initialValue: training.name)
        _duration = State(initialValue: "\(training.duration)")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Training Info")) {
                    TextField("Training Name", text: $name)
                    TextField("Duration (mins)", text: $duration)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Training")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveChanges() {
        guard let durationInt = Int(duration) else { return }
        training.name = name
        training.duration = durationInt

        try? context.save()
        viewModel
            .fetchTrainings(context: context) //  Refresh the list after editing
    }
}

struct AddTrainingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(
        \.modelContext
    ) private var context //  Ensure SwiftData context is available
    @State private var name: String = ""
    @State private var duration: String = ""
    @State private var selectedImage: UIImage?
    @State private var showPhotoPicker = false
    var viewModel: TrainViewModel

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 12) {
                    Text("New Training")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Fill in the details and add an optional image")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)

                Form {
                    Section(header: Text("Training Info")) {
                        TextField("Enter training name", text: $name)
                            .textFieldStyle(.roundedBorder)

                        TextField("Enter duration (mins)", text: $duration)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)

                    }
                    
                    Section(header: Text("Image (Optional)")) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 3)
                        } else {
                            Button {
                                showPhotoPicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    Text("Select an Image")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Save & Cancel Buttons
                HStack(spacing: 15) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .frame(width: 130, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button("Save") {
                        print(" DEBUG: Name = \(name), Duration = \(duration)")
                        guard let durationInt = Int(duration), !name.isEmpty else {
                            print(
                                " DEBUG: Invalid input - Name or Duration missing"
                            )
                            return
                        }
                        viewModel
                            .addTraining(
                                context: context,
                                name: name,
                                duration: durationInt,
                                image: selectedImage
                            )
                        dismiss()
                    }
                    .frame(width: 130, height: 50)
                    .background(
                        name.isEmpty || duration.isEmpty ? Color.gray
                            .opacity(0.5) : Color.purple
                    )
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(name.isEmpty || duration.isEmpty)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Add Training")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(
                                .system(size: 12, weight: .bold)
                            ) // Slightly bigger
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.purple)
                            .clipShape(Circle())

                    }
                }
            }
            .sheet(isPresented: $showPhotoPicker) {
                PhotoPicker(selectedImage: $selectedImage)
            }
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: Context
    ) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}
