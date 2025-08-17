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
    }
    
    func completeSession(_ session: Session) {
        var completedSession = session
        completedSession.status = .finished
        completedSession.completedAt = Date()
        completedSession.executionSeconds = Int(Date().timeIntervalSince(session.startedAt ?? Date()))
        
        pastSessions.insert(completedSession, at: 0)
        activeSession = nil
    }
    
    func cancelSession(_ session: Session) {
        var cancelledSession = session
        cancelledSession.status = .cancelled
        cancelledSession.completedAt = Date()
        
        pastSessions.insert(cancelledSession, at: 0)
        activeSession = nil
    }
    
    private func loadSessions() {
        // TODO: Load from Firebase when integrated
        // For now, load mock data
        pastSessions = [
            Session(
                userId: "user123",
                workoutId: "workout1",
                status: .finished,
                startedAt: Date().addingTimeInterval(-3600),
                completedAt: Date().addingTimeInterval(-1800),
                exercises: [],
                circuits: [],
                notes: "Great workout!"
            ),
            Session(
                userId: "user123",
                workoutId: "workout2",
                status: .finished,
                startedAt: Date().addingTimeInterval(-7200),
                completedAt: Date().addingTimeInterval(-5400),
                exercises: [],
                circuits: [],
                notes: "Felt strong today"
            )
        ]
    }
    
    private func loadWorkouts() {
        // TODO: Load from Firebase when integrated
        // For now, load mock data
        workouts = [
            Workout(
                id: "workout1",
                userId: "user123",
                name: "Push Day",
                exercises: [],
                circuits: []
            ),
            Workout(
                id: "workout2",
                userId: "user123",
                name: "Pull Day",
                exercises: [],
                circuits: []
            ),
            Workout(
                id: "workout3",
                userId: "user123",
                name: "Circuit Training",
                exercises: [],
                circuits: []
            )
        ]
    }
}
