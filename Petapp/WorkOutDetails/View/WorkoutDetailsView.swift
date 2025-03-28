//
//  WorkoutDetailsView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 07/03/25.
//
import SwiftUI

struct WorkoutDetailsView: View {
    @Environment(\.dismiss) private var dismiss //  Fix: Add dismiss environment
    @StateObject var viewModel = WorkoutDetailsViewModel()
    var workout: Workout
    @State private var isSheetShow = false

    var body: some View {
        VStack(spacing: 12) {
            // Workout Title
            VStack {
                Text(workout.name.isEmpty ? "Unknown Workout" : workout.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.5))
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Running Wheel View
            RunningWheelView()
                .frame(height: 200)
                .padding(.horizontal)
            
            // Default Description Instead of Exercises
            Text(
                "Every dog and cat should get daily exercise. Walking, running, or playing is essential for their health."
            )
            .font(.body)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // Timer Display
            Text(timeString(viewModel.timeRemaining))
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            // Control Buttons
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.resetTimer(duration: workout.duration)
                }) {
                    Text("Restart")
                        .frame(width: 100, height: 40)
                        .background(Color.white)
                        .foregroundColor(.purple)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple, lineWidth: 2)
                        )
                }
                
                Button(action: {
                    if viewModel.isPaused {
                        viewModel.startTimer(duration: viewModel.timeRemaining)
                    } else {
                        viewModel.pauseTimer()
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill") // Play/Pause icon
                            .font(.title2)

                        Text(viewModel.isPaused ? "Play" : "Pause")
                            .fontWeight(.bold)
                    }
                    .frame(width: 120, height: 45) // Adjusted size
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 4) // Added shadow for better UI
                }
                .onChange(of: viewModel.timeRemaining, { oldValue, newValue in
                    if newValue == 0 {
                        isSheetShow = true
                    }
                })
                .onAppear {
                    viewModel.isPaused = true // Ensure it starts in "Play" state
                }
            }
    
            .padding(.bottom, 20)
            
            // Skip Button
            Button(action: {
                // Handle skip action
            }) {
                Text("Skip")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .disabled(isSheetShow)
        .opacity(isSheetShow ? 0 : 1)
        // for showing sucess screen
        .overlay(alignment: .center, content: {
            if isSheetShow {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .frame(width: 350,height: 500)
                
            
                    .overlay {
                        SheetView()
                    }
            }
            
        })
        .onDisappear {
            viewModel.stopTimer()
        }
        
        .presentationDetents([.medium])
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(
                placement: .topBarLeading
            ) { //  Custom Purple Back Button
                Button(action: {
                    dismiss() //  Now dismiss() works
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Back")
                    }
                    .foregroundColor(.purple) //  Purple back button
                }
            }
        }
    }
}

// Helper function to format time as "MM:SS"
private func timeString(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}


// MARK: - RunningWheelView
struct RunningWheelView: View {
    @State private var isWheelRotating = false
    @State private var isWalking = false
    
    var body: some View {
        ZStack {
            // Detailed Rotating Wheel
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 8
                    )
                    .frame(width: 180, height: 180)
                
                // Wheel spokes
                ForEach(0..<8) { i in
                    Rectangle()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 4, height: 80)
                        .offset(y: -40)
                        .rotationEffect(.degrees(Double(i) * 45))
                }
            }
            .rotationEffect(.degrees(isWheelRotating ? -360 : 0))
            .animation(
                Animation
                    .linear(duration: 2)
                    .repeatForever(autoreverses: false),
                value: isWheelRotating
            )
            
            // Cat at the bottom of the wheel
            Image(systemName: "cat.fill")
                .resizable()
                .overlay(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .mask(Image(systemName: "cat.fill").resizable())
                )
                .frame(width: 40, height: 40)
                .offset(y: 60 + (isWalking ? 5 : 0))
                .animation(
                    Animation
                        .easeInOut(duration: 0.3)
                        .repeatForever(autoreverses: true),
                    value: isWalking
                )
                .scaleEffect(x: -1.0) // Flipping the cat sideways
        }
        .onAppear {
            isWheelRotating = true
            isWalking = true
        }
    }
}

// MARK: - Preview
struct WorkoutDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleWorkout = Workout(
            name: "Sample Workout",
            duration: 240, //  5 minutes
            trainingName: "Strength Training"
        )
        
        return WorkoutDetailsView(workout: sampleWorkout)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
