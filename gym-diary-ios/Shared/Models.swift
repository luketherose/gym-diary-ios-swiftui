//
//  Models.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import Foundation
// import FirebaseFirestore

// MARK: - Exercise Categories and Variants
enum ExerciseCategory: String, CaseIterable, Codable {
    case machine = "machine"
    case bodyweight = "bodyweight"
    case dumbbells = "dumbbells"
    case barbell = "barbell"
    case cable = "cable"
    case multipower = "multipower"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .machine: return "Machine"
        case .bodyweight: return "Bodyweight"
        case .dumbbells: return "Dumbbells"
        case .barbell: return "Barbell"
        case .cable: return "Cable"
        case .multipower: return "Multipower"
        case .other: return "Other"
        }
    }
}

enum ExerciseVariant: String, CaseIterable, Codable {
    case flat = "flat"
    case incline = "incline"
    case decline = "decline"
    case wideGrip = "wide-grip"
    case closeGrip = "close-grip"
    case reverseGrip = "reverse-grip"
    case neutralGrip = "neutral-grip"
    case front = "front"
    case backHighbar = "back-highbar"
    case backLowbar = "back-lowbar"
    case pause = "pause"
    case box = "box"
    case goblet = "goblet"
    case safetyBar = "safety-bar"
    case trapBar = "trap-bar"
    case conventional = "conventional"
    case sumo = "sumo"
    case rdl = "rdl"
    case stiffLeg = "stiff-leg"
    case seated = "seated"
    case standing = "standing"
    case pushPress = "push-press"
    case arnold = "arnold"
    case preacher = "preacher"
    case ezBar = "ez-bar"
    case rope = "rope"
    case cable = "cable"
    case walking = "walking"
    case reverse = "reverse"
    case bulgarian = "bulgarian"
    
    var displayName: String {
        switch self {
        case .flat: return "Flat"
        case .incline: return "Incline"
        case .decline: return "Decline"
        case .wideGrip: return "Wide Grip"
        case .closeGrip: return "Close Grip"
        case .reverseGrip: return "Reverse Grip"
        case .neutralGrip: return "Neutral Grip"
        case .front: return "Front"
        case .backHighbar: return "Back High Bar"
        case .backLowbar: return "Back Low Bar"
        case .pause: return "Pause"
        case .box: return "Box"
        case .goblet: return "Goblet"
        case .safetyBar: return "Safety Bar"
        case .trapBar: return "Trap Bar"
        case .conventional: return "Conventional"
        case .sumo: return "Sumo"
        case .rdl: return "RDL"
        case .stiffLeg: return "Stiff Leg"
        case .seated: return "Seated"
        case .standing: return "Standing"
        case .pushPress: return "Push Press"
        case .arnold: return "Arnold"
        case .preacher: return "Preacher"
        case .ezBar: return "EZ Bar"
        case .rope: return "Rope"
        case .cable: return "Cable"
        case .walking: return "Walking"
        case .reverse: return "Reverse"
        case .bulgarian: return "Bulgarian"
        }
    }
}

// MARK: - Session Status
enum SessionStatus: String, CaseIterable, Codable {
    case created = "created"
    case inProgress = "in_progress"
    case finished = "finished"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .created: return "Created"
        case .inProgress: return "In Progress"
        case .finished: return "Finished"
        case .cancelled: return "Cancelled"
        }
    }
}

// MARK: - Units and Theme
enum Units: String, CaseIterable, Codable {
    case kg = "kg"
    case lbs = "lbs"
    
    var displayName: String {
        switch self {
        case .kg: return "Kilograms"
        case .lbs: return "Pounds"
        }
    }
}

enum Theme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .auto: return "Auto"
        }
    }
}

// MARK: - Main Models
struct Workout: Identifiable, Codable {
    let id: String
    let userId: String
    var name: String
    let description: String?
    var exercises: [Exercise]
    let createdAt: Date
    let updatedAt: Date
    let lastExecuted: Date?
    let sectionId: String
    var iconName: String
    var colorName: String
    var chipText: String
    
    init(id: String = UUID().uuidString,
         userId: String,
         name: String,
         description: String? = nil,
         exercises: [Exercise] = [],
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         lastExecuted: Date? = nil,
         sectionId: String = "",
         iconName: String = "dumbbell.fill",
         colorName: String = "Blue",
         chipText: String = "") {
        self.id = id
        self.userId = userId
        self.name = name
        self.description = description
        self.exercises = exercises
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastExecuted = lastExecuted
        self.sectionId = sectionId
        self.iconName = iconName
        self.colorName = colorName
        self.chipText = chipText
    }
}

struct Exercise: Identifiable, Codable {
    let id: String
    let workoutId: String
    var name: String
    let category: ExerciseCategory
    var variants: [ExerciseVariant]
    var sets: [ExerciseSet]
    let order: Int
    let restTime: Int
    var notes: String?
    
    init(id: String = UUID().uuidString,
         workoutId: String,
         name: String,
         category: ExerciseCategory,
         variants: [ExerciseVariant] = [],
         sets: [ExerciseSet] = [],
         order: Int = 0,
         restTime: Int = 60,
         notes: String? = nil) {
        self.id = id
        self.workoutId = workoutId
        self.name = name
        self.category = category
        self.variants = variants
        self.sets = sets
        self.order = order
        self.restTime = restTime
        self.notes = notes
    }
}

struct ExerciseSet: Identifiable, Codable, Equatable {
    let id: String
    let exerciseId: String
    var reps: Int
    var weight: Double
    var restTime: Int // in seconds
    var rpe: Int?
    let completed: Bool
    let order: Int
    
    init(id: String = UUID().uuidString,
         exerciseId: String,
         reps: Int,
         weight: Double = 0,
         restTime: Int = 60,
          rpe: Int? = nil,
         completed: Bool = false,
         order: Int = 0) {
        self.id = id
        self.exerciseId = exerciseId
        self.reps = reps
        self.weight = weight
        self.restTime = restTime
        self.rpe = rpe
        self.completed = completed
        self.order = order
    }
    
    static func == (lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
        lhs.id == rhs.id
    }
}

struct Circuit: Identifiable, Codable {
    let id: String
    let workoutId: String
    let name: String
    let exercises: [CircuitExercise]
    let restBetweenCircuits: Int // in seconds
    let order: Int
    
    init(id: String = UUID().uuidString,
         workoutId: String,
         name: String,
         exercises: [CircuitExercise] = [],
         restBetweenCircuits: Int = 120,
         order: Int = 0) {
        self.id = id
        self.workoutId = workoutId
        self.name = name
        self.exercises = exercises
        self.restBetweenCircuits = restBetweenCircuits
        self.order = order
    }
}

struct CircuitExercise: Identifiable, Codable {
    let id: String
    let circuitId: String
    let exerciseId: String
    let order: Int
    let restAfter: Int // in seconds
    
    init(id: String = UUID().uuidString,
         circuitId: String,
         exerciseId: String,
         order: Int = 0,
         restAfter: Int = 0) {
        self.id = id
        self.circuitId = circuitId
        self.exerciseId = exerciseId
        self.order = order
        self.restAfter = restAfter
    }
}

struct Session: Identifiable, Codable {
    let id: String
    let userId: String
    let workoutId: String
    let status: SessionStatus
    let startedAt: Date?
    let completedAt: Date?
    let exercises: [SessionExercise]
    let notes: String?
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         workoutId: String,
         status: SessionStatus = .created,
         startedAt: Date? = nil,
         completedAt: Date? = nil,
         exercises: [SessionExercise] = [],
         notes: String? = nil,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.workoutId = workoutId
        self.status = status
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.exercises = exercises
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct SessionExercise: Identifiable, Codable {
    let id: String
    let sessionId: String
    let exerciseId: String
    let sets: [SessionSet]
    let completed: Bool
    let order: Int
    
    init(id: String = UUID().uuidString,
         sessionId: String,
         exerciseId: String,
         sets: [SessionSet] = [],
         completed: Bool = false,
         order: Int = 0) {
        self.id = id
        self.sessionId = sessionId
        self.exerciseId = exerciseId
        self.sets = sets
        self.completed = completed
        self.order = order
    }
}

struct SessionSet: Identifiable, Codable {
    let id: String
    let sessionExerciseId: String
    let reps: Int
    let weight: Double
    let completed: Bool
    let completedAt: Date?
    let order: Int
    
    init(id: String = UUID().uuidString,
         sessionExerciseId: String,
         reps: Int,
         weight: Double = 0,
         completed: Bool = false,
         completedAt: Date? = nil,
         order: Int = 0) {
        self.id = id
        self.sessionExerciseId = sessionExerciseId
        self.reps = reps
        self.weight = weight
        self.completed = completed
        self.completedAt = completedAt
        self.order = order
    }
}

struct UserSettings: Identifiable, Codable {
    let id: String
    let userId: String
    let defaultRestTime: Int // in seconds
    let units: Units
    let theme: Theme
    let timerNotifications: Bool
    let sounds: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         defaultRestTime: Int = 60,
         units: Units = .kg,
         theme: Theme = .auto,
         timerNotifications: Bool = true,
         sounds: Bool = true,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.defaultRestTime = defaultRestTime
        self.units = units
        self.theme = theme
        self.timerNotifications = timerNotifications
        self.sounds = sounds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct WorkoutSection: Identifiable, Codable {
    let id: String
    let userId: String
    let name: String
    var workouts: [Workout]
    var isExpanded: Bool
    let order: Int
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String = UUID().uuidString,
         userId: String,
         name: String,
         workouts: [Workout] = [],
         isExpanded: Bool = true,
         order: Int = 0,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.name = name
        self.workouts = workouts
        self.isExpanded = isExpanded
        self.order = order
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Firebase Extensions (Temporarily Commented)
/*
extension Workout {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.ownerId = data["ownerId"] as? String ?? ""
        self.date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
        self.title = data["title"] as? String ?? ""
        self.notes = data["notes"] as? String
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        self.updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
    }
}

extension Exercise {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.name = data["name"] as? String ?? ""
        self.muscleGroup = data["muscleGroup"] as? String
        self.category = ExerciseCategory(rawValue: data["category"] as? String ?? "") ?? .other
        self.variants = [] // TODO: map from array when Firebase integration is enabled
        self.order = data["order"] as? Int ?? 0
        self.imageUrl = data["imageUrl"] as? String
        self.defaultRestSec = data["defaultRestSec"] as? Int
        self.isCircuit = data["isCircuit"] as? Bool
        self.circuitId = data["circuitId"] as? String
    }
}

extension Session {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.ownerId = data["ownerId"] as? String ?? ""
        self.workoutTitle = data["workoutTitle"] as? String ?? ""
        self.workoutId = data["workoutId"] as? String ?? ""
        self.startedAt = (data["startedAt"] as? Timestamp)?.dateValue() ?? Date()
        self.endedAt = (data["endedAt"] as? Timestamp)?.dateValue()
        self.executionSeconds = data["executionSeconds"] as? Int
        self.status = SessionStatus(rawValue: data["status"] as? String ?? "") ?? .created
    }
}

extension UserSettings {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.ownerId = data["ownerId"] as? String ?? ""
        self.defaultRestSec = data["defaultRestSec"] as? Int ?? 60
        self.units = Units(rawValue: data["units"] as? String ?? "") ?? .kg
        self.theme = Theme(rawValue: data["theme"] as? String ?? "") ?? .auto
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        self.updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
    }
}
*/
