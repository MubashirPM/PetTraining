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
    @Published var timeRemaining: Int = 3 //  Always start at 10 min
    @Published var isPaused: Bool = false
    
    // Timer properties
    private var timer: Timer?
    
    func startTimer(duration: Int) {
        if timer != nil { return } // Prevent multiple timers

        isPaused = false
        timeRemaining = duration
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
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
        startTimer(duration: 3) //  Force restart with 5:30 min
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
