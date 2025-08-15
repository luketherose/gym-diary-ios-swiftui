//
//  FirebaseManager.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import Foundation
// import FirebaseCore
// import FirebaseFirestore
// import FirebaseAuth

// Simple User struct for now
struct User {
    let uid: String
    let email: String?
    let displayName: String?
}

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    // let db = Firestore.firestore()
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private init() {
        // setupAuthStateListener()
    }
    
    // MARK: - Authentication
    private func setupAuthStateListener() {
        // Auth.auth().addStateDidChangeListener { [weak self] _, user in
        //     DispatchQueue.main.async {
        //         self?.currentUser = user
        //         self?.isAuthenticated = user != nil
        //     }
        // }
    }
    
    func signInAnonymously() async throws {
        // let result = try await Auth.auth().signInAnonymously()
        // DispatchQueue.main.async {
        //     self.currentUser = result.user
        //     self.isAuthenticated = true
        // }
    }
    
    func signOut() throws {
        // try Auth.auth().signOut()
        // DispatchQueue.main.async {
        //     self.currentUser = nil
        //     self.isAuthenticated = false
        // }
    }
    
    // MARK: - User Settings
    func getUserSettings() async throws -> UserSettings? {
        // guard let userId = currentUser?.uid else { return nil }
        
        // let document = try await db.collection("userSettings").document(userId).getDocument()
        // return UserSettings(document: document)
        return nil
    }
    
    func createUserSettings(_ settings: UserSettings) async throws {
        // let data: [String: Any] = [
        //     "ownerId": settings.ownerId,
        //     "defaultRestSec": settings.defaultRestSec,
        //     "units": settings.units.rawValue,
        //     "theme": settings.theme.rawValue,
        //     "createdAt": Timestamp(date: settings.createdAt),
        //     "updatedAt": Timestamp(date: settings.updatedAt)
        // ]
        
        // try await db.collection("userSettings").document(settings.id).setData(data)
    }
    
    func updateUserSettings(_ settings: UserSettings) async throws {
        // let data: [String: Any] = [
        //     "defaultRestSec": settings.defaultRestSec,
        //     "units": settings.units.rawValue,
        //     "theme": settings.theme.rawValue,
        //     "updatedAt": Timestamp(date: Date())
        // ]
        
        // try await db.collection("userSettings").document(settings.id).updateData(data)
    }
    
    // MARK: - Workouts
    func getWorkouts() async throws -> [Workout] {
        // guard let userId = currentUser?.uid else { return [] }
        
        // let snapshot = try await db.collection("workouts")
        //     .whereField("ownerId", isEqualTo: userId)
        //     .order(by: "date", descending: true)
        //     .getDocuments()
        
        // return snapshot.documents.compactMap { Workout(document: $0) }
        return []
    }
    
    func createWorkout(_ workout: Workout) async throws -> String {
        // let data: [String: Any] = [
        //     "ownerId": workout.ownerId,
        //     "date": Timestamp(date: workout.date),
        //     "title": workout.title,
        //     "notes": workout.notes as Any,
        //     "createdAt": Timestamp(date: workout.createdAt),
        //     "updatedAt": Timestamp(date: workout.updatedAt)
        // ]
        
        // let documentRef = try await db.collection("workouts").addDocument(data: data)
        // return documentRef.documentID
        return ""
    }
    
    func updateWorkout(_ workout: Workout) async throws {
        // let data: [String: Any] = [
        //     "title": workout.title,
        //     "notes": workout.notes as Any,
        //     "updatedAt": Timestamp(date: Date())
        // ]
        
        // try await db.collection("workouts").document(workout.id).updateData(data)
    }
    
    func deleteWorkout(_ workoutId: String) async throws {
        // try await db.collection("workouts").document(workoutId).delete()
    }
    
    // MARK: - Exercises
    func getExercises(for workoutId: String) async throws -> [Exercise] {
        // let snapshot = try await db.collection("workouts")
        //     .document(workoutId)
        //     .collection("exercises")
        //     .order(by: "order")
        //     .getDocuments()
        
        // return snapshot.documents.compactMap { Exercise(document: $0) }
        return []
    }
    
    func addExercise(_ exercise: Exercise, to workoutId: String) async throws -> String {
        // let data: [String: Any] = [
        //     "name": exercise.name,
        //     "muscleGroup": exercise.muscleGroup as Any,
        //     "category": exercise.category.rawValue,
        //     "variant": exercise.variant?.rawValue as Any,
        //     "order": exercise.order,
        //     "imageUrl": exercise.imageUrl as Any,
        //     "defaultRestSec": exercise.defaultRestSec as Any,
        //     "isCircuit": exercise.isCircuit as Any,
        //     "circuitId": exercise.circuitId as Any
        // ]
        
        // let documentRef = try await db.collection("workouts")
        //     .document(workoutId)
        //     .collection("exercises")
        //     .addDocument(data: data)
        
        // return documentRef.documentID
        return ""
    }
    
    // MARK: - Sessions
    func getSessions() async throws -> [Session] {
        // guard let userId = currentUser?.uid else { return [] }
        
        // let snapshot = try await db.collection("sessions")
        //     .whereField("ownerId", isEqualTo: userId)
        //     .order(by: "endedAt", descending: true)
        //     .getDocuments()
        
        // return snapshot.documents.compactMap { Session(document: $0) }
        return []
    }
    
    func getActiveSession() async throws -> Session? {
        // guard let userId = currentUser?.uid else { return nil }
        
        // let snapshot = try await db.collection("sessions")
        //     .whereField("ownerId", isEqualTo: userId)
        //     .whereField("status", isEqualTo: SessionStatus.inProgress.rawValue)
        //     .limit(to: 1)
        //     .getDocuments()
        
        // return snapshot.documents.first.flatMap { Session(document: $0) }
        return nil
    }
    
    func createSession(_ session: Session) async throws -> String {
        // let data: [String: Any] = [
        //     "ownerId": session.ownerId,
        //     "workoutTitle": session.workoutTitle,
        //     "workoutId": session.workoutId,
        //     "startedAt": Timestamp(date: session.startedAt),
        //     "endedAt": session.endedAt.map { Timestamp(date: $0) } as Any,
        //     "executionSeconds": session.executionSeconds as Any,
        //     "status": session.status.rawValue
        // ]
        
        // let documentRef = try await db.collection("sessions").addDocument(data: data)
        // return documentRef.documentID
        return ""
    }
    
    func updateSession(_ session: Session) async throws {
        // let data: [String: Any] = [
        //     "endedAt": session.endedAt.map { Timestamp(date: $0) } as Any,
        //     "executionSeconds": session.executionSeconds as Any,
        //     "status": session.status.rawValue
        // ]
        
        // try await db.collection("sessions").document(session.id).updateData(data)
    }
}
