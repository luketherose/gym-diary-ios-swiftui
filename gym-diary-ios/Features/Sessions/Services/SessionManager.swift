//
//  SessionManager.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import Foundation
import SwiftUI

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var activeSession: Session? = nil
    @Published var pastSessions: [Session] = []
    @Published var shouldNavigateToSessions = false
    @Published var workouts: [Workout] = []
    @Published var sessionTimer: Timer?
    
    private init() {
        loadSessions()
        loadWorkouts()
    }
    
    func startSession(from workout: Workout) {
        let newSession = Session(
            userId: "user123",
            workoutId: workout.id,
            status: .inProgress,
            startedAt: Date(),
            exercises: workout.exercises.map { exercise in
                SessionExercise(
                    sessionId: UUID().uuidString,
                    exerciseId: exercise.id,
                    sets: exercise.sets.map { set in
                        SessionSet(
                            sessionExerciseId: UUID().uuidString,
                            reps: set.reps,
                            weight: set.weight,
                            completed: false,
                            order: set.order
                        )
                    },
                    completed: false,
                    order: exercise.order
                )
            },
            circuits: workout.circuits.map { circuit in
                SessionCircuit(
                    sessionId: UUID().uuidString,
                    circuitId: circuit.id,
                    sets: [], // TODO: Implement circuit sets
                    completed: false,
                    order: circuit.order
                )
            }
        )
        
        activeSession = newSession
        shouldNavigateToSessions = true
        
        // Start timer to update duration
        startSessionTimer()
    }
    
    func completeSession(_ session: Session) {
        var completedSession = session
        completedSession.status = .finished
        completedSession.completedAt = Date()
        completedSession.executionSeconds = Int(Date().timeIntervalSince(session.startedAt ?? Date()))
        
        pastSessions.insert(completedSession, at: 0)
        activeSession = nil
        
        // Stop timer
        stopSessionTimer()
    }
    
    func cancelSession(_ session: Session) {
        var cancelledSession = session
        cancelledSession.status = .cancelled
        cancelledSession.completedAt = Date()
        
        pastSessions.insert(cancelledSession, at: 0)
        activeSession = nil
        
        // Stop timer
        stopSessionTimer()
    }
    
    private func loadSessions() {
        // TODO: Load from Firebase when integrated
        // For now, start with empty state
        pastSessions = []
    }
    
    private func loadWorkouts() {
        // TODO: Load from Firebase when integrated
        // For now, start with empty state
        workouts = []
    }
    
    private func startSessionTimer() {
        stopSessionTimer() // Stop any existing timer
        
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // Force UI update by triggering objectWillChange
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    private func stopSessionTimer() {
        sessionTimer?.invalidate()
        sessionTimer = nil
    }
}
