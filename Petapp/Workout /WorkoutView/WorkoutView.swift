//
//  WorkoutView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 28/02/25.
//

import SwiftUI
import SwiftData
import SwiftUI

//screen that displays a list of workouts for a specific training session
struct WorkoutView: View {
    @Environment(\.dismiss) private var dismiss //  handle navigation dismissals
    @Environment(\.modelContext) private var context // swiftdata context
    @StateObject var viewModel = WorkoutViewModel() // manage workout logic 
    @State private var showAddSheet = false // control the workout sheet
    var trainingName: String // name the training sections

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header for the training name
                Text("Training: \(trainingName)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)

                //  List or Empty State
                if viewModel.workouts.isEmpty {
                    EmptyWorkoutView()
                        .frame(maxHeight: .infinity) // Center empty state vertically
                        .padding(.top, 40)
                } else {
                    List {
                        Section {
                            ForEach(viewModel.workouts) { workout in
                                VStack(alignment: .leading, spacing: 12) {
                                    WorkoutRowView(workout: workout, viewModel: viewModel)
                                    
                                    Divider()
                                        .padding(.vertical, 4)
                                }
                                .padding(.vertical, 8)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12)) //  Rounded list items
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .background(Color(.systemGroupedBackground))
                    .transition(.opacity) // Smooth transition effect
                }
            }
            .onAppear {
                // to ensure the ui update smoothly
                DispatchQueue.main.async {
                    viewModel.fetchWorkouts(trainingName: trainingName, context: context)
                }
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) //  Hide default back button
            .toolbar {
                //  Custom Purple Back Button
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

                //  Add Button with Shadow
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.purple)
                            .shadow(color: Color.purple.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddWorkoutView(viewModel: viewModel, trainingName: trainingName)
                    .presentationDetents([.medium, .large]) //  Modern modal effect
                    .presentationCornerRadius(20)
            }
        }
    }
}
// showing individual workout item
struct WorkoutRowView: View {
    let workout: Workout
    let viewModel: WorkoutViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationLink(destination: WorkoutDetailsView(workout: workout)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(workout.name)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text("Duration: \(workout.duration) mins")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.vertical, 5)
        }
        .swipeActions {
            Button(role: .destructive) {
                viewModel.deleteWorkout(workout, context: context)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Empty Workout View
struct EmptyWorkoutView: View {
    var body: some View {
        VStack {
            Image(systemName: "list.bullet.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.7))
                .padding(.bottom, 10)

            Text("No Workouts Available")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)

            Text("Tap '+' to add a new workout.")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Add Workout View (Exercises Removed)
struct AddWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var name: String = ""
    @State private var duration: String = ""

    var viewModel: WorkoutViewModel
    let trainingName: String  //  Added missing trainingName

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Workout Info")) {
                        TextField("Workout Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Duration (mins)", text: $duration)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                Spacer()
                
                Button(action: saveWorkout) {
                    Text("Save Workout")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(name.isEmpty || duration.isEmpty ? Color.gray : Color.purple)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                .disabled(name.isEmpty || duration.isEmpty)
                .padding(.bottom, 20)
            }
            .navigationTitle("Add Workout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "xmark")
                                        .font(.system(size: 15, weight: .bold)) // Slightly bigger
                                        .foregroundColor(.white) // White X
                                        .padding(8)
                                        .background(Color.purple) // Red background
                                        .clipShape(Circle()) // Makes it circular
                    }
                }
            }
        }
    }

    private func saveWorkout() {
        guard let durationInt = Int(duration), !name.isEmpty else { return }
        
        print("Saving workout: \(name), Duration: \(durationInt)")

        viewModel.addWorkout(context: context, name: name, duration: durationInt, exercises: [], trainingName: trainingName) //  Removed exercises

        dismiss()
    }
}
