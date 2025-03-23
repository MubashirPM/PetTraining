//
//  WorkoutDetailsViewModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 07/03/25.
//

import SwiftUI
import Foundation
import Combine

class WorkoutDetailsViewModel: ObservableObject {
    // Published properties
    @Published var timeRemaining: Int = 600 //  Always start at 10 min
    @Published var isPaused: Bool = false
    
    // Timer properties
    private var timer: Timer?
    
    //  Start the timer with a fixed 600 sec duration
    func startTimer(duration: Int) {
        print("DEBUG: Starting Timer with Duration: 330 sec") //  Debug print
        // Always start at 5:30 minutes (330 sec)
        timeRemaining = 600
        isPaused = false

        // Stop any previous timer
        timer?.invalidate()

        // Start a new countdown timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
            }
        }

        // Ensure the timer runs in the main thread
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    //  Pause the timer
    func pauseTimer() {
        print("DEBUG: Timer Paused at \(timeRemaining) sec") //  Debug print
        timer?.invalidate()
        isPaused = true
    }
    
    //  Reset the timer to 330 sec
    func resetTimer(duration: Int) {
        print("DEBUG: Resetting Timer to 330 sec") //  Debug print
        stopTimer()
        startTimer(duration: 600) //  Force restart with 5:30 min
    }
    
    // Stop the timer completely
    func stopTimer() {
        print("DEBUG: Timer Stopped") //  Debug print
        timer?.invalidate()
        timer = nil
        isPaused = true
    }
    
    //  Ensure timer stops when the view model is deallocated
    deinit {
        stopTimer()
    }
}
