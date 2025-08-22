import Foundation
import SwiftUI

@MainActor
class AddExerciseViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var query: String = ""
    @Published var selectedMuscleGroup: String = ""
    @Published var filtered: [Archetype] = []
    @Published var selectedArchetype: Archetype?
    @Published var selectedAttrs: [String: Any] = [:]
    @Published var previewName: String = ""
    
    // MARK: - Private Properties
    private let catalog = ExerciseCatalog.shared
    private let USE_FIRESTORE = false // Flag for future Firestore integration
    
    // MARK: - Initialization
    init() {
        print("🔍 AddExerciseViewModel: Starting initialization...")
        
        // Force catalog initialization
        let catalogInstance = ExerciseCatalog.shared
        print("🔍 AddExerciseViewModel: Catalog instance created")
        print("🔍 AddExerciseViewModel: Catalog has \(catalogInstance.archetypes.count) archetypes")
        
        // Show all archetypes initially
        self.filtered = catalogInstance.archetypes
        print("🔍 AddExerciseViewModel: Initialized with \(filtered.count) filtered archetypes")
        
        // Debug: Print first few archetypes
        for (index, archetype) in filtered.prefix(3).enumerated() {
            print("🔍 AddExerciseViewModel: Archetype \(index): \(archetype.displayName)")
        }
        
        if filtered.isEmpty {
            print("❌ AddExerciseViewModel: WARNING - No archetypes found in catalog!")
        }
    }
    
    // MARK: - Public Methods
    
    /// Handle query changes and update filtered results
    func onQueryChanged() {
        updateFilteredResults()
    }
    
    /// Handle muscle group selection and update filtered results
    func onMuscleGroupChanged() {
        updateFilteredResults()
    }
    
    /// Handle enum attribute selection
    func onPick(key: String, value: String) {
        selectedAttrs[key] = value
        updatePreviewName()
    }
    
    /// Handle boolean attribute toggle
    func onToggle(key: String, value: Bool) {
        selectedAttrs[key] = value
        updatePreviewName()
    }
    
    /// Select an archetype and initialize its attributes
    func selectArchetype(_ archetype: Archetype) {
        selectedArchetype = archetype
        selectedAttrs.removeAll()
        
        // Initialize attributes with default values
        for attrKey in archetype.allowedAttributes {
            if let attribute = catalog.attributes.first(where: { $0.key == attrKey }) {
                if let defaultValue = attribute.default {
                    selectedAttrs[attrKey] = defaultValue
                } else if let values = attribute.values, !values.isEmpty {
                    // Fallback to first value if no default
                    selectedAttrs[attrKey] = values.first
                }
            }
        }
        
        // Initialize required attributes if any
        let requiredAttrs = catalog.rules
            .filter { $0.scope == "archetype" && $0.archetype == archetype.key && $0.require != nil }
            .compactMap { $0.require }
            .flatMap { $0 }
        
        for attr in requiredAttrs {
            let values = catalog.allowedValues(for: attr, archetype: archetype, current: [:])
            if !values.isEmpty {
                selectedAttrs[attr] = values.first
            }
        }
        
        updatePreviewName()
    }
    
    /// Clear archetype selection
    func clearArchetype() {
        selectedArchetype = nil
        selectedAttrs.removeAll()
        updatePreviewName()
    }
    
    /// Get allowed values for an attribute, ordered with default first
    func allowedValues(for attributeKey: String) -> [String] {
        let values = catalog.allowedValues(for: attributeKey, archetype: selectedArchetype, current: selectedAttrs)
        
        // Find the default value for this attribute
        guard let attribute = catalog.attributes.first(where: { $0.key == attributeKey }),
              let defaultValue = attribute.default else {
            return Array(values)
        }
        
        // Sort with default first
        var sortedValues = Array(values)
        if let defaultIndex = sortedValues.firstIndex(of: defaultValue) {
            sortedValues.remove(at: defaultIndex)
            sortedValues.insert(defaultValue, at: 0)
        }
        
        return sortedValues
    }
    
    /// Check if a value is disabled for an attribute
    func isValueDisabled(for attributeKey: String, value: String) -> Bool {
        let allowed = allowedValues(for: attributeKey)
        return !allowed.contains(value)
    }
    

    
    /// Create an Exercise instance from current selection
    func createExercise(workoutId: String) -> Exercise? {
        guard let archetype = selectedArchetype else { return nil }
        
        // Map archetype to ExerciseCategory
        let category = mapArchetypeToCategory(archetype)
        
        // Create exercise name from preview
        let exerciseName = previewName.isEmpty ? archetype.displayName : previewName
        
        // Create default sets
        let defaultSets = [
            ExerciseSet(
                exerciseId: UUID().uuidString,
                reps: 10,
                weight: 0,
                restTime: 60
            )
        ]
        
        return Exercise(
            workoutId: workoutId,
            name: exerciseName,
            category: category,
            variants: [], // We're using the new attribute system instead of variants
            sets: defaultSets,
            order: 0,
            restTime: 60,
            notes: nil
        )
    }
    
    // MARK: - Private Methods
    
    private func updateFilteredResults() {
        print("🔍 AddExerciseViewModel: updateFilteredResults called with query: '\(query)' and muscle group: '\(selectedMuscleGroup)'")
        
        var results = catalog.archetypes
        
        // Filter by muscle group if selected
        if !selectedMuscleGroup.isEmpty {
            results = results.filter { archetype in
                archetype.primaryMuscle == selectedMuscleGroup || 
                archetype.secondaryMuscles.contains(selectedMuscleGroup) ||
                archetype.primarySubgroups.contains { $0.lowercased().contains(selectedMuscleGroup.lowercased()) } ||
                archetype.secondarySubgroups.contains { $0.lowercased().contains(selectedMuscleGroup.lowercased()) }
            }
            print("🔍 AddExerciseViewModel: Filtered by muscle group '\(selectedMuscleGroup)', got \(results.count) results")
        }
        
        // Filter by query if provided
        if !query.isEmpty {
            let searchResults = catalog.searchArchetypes(query: query)
            // Intersect with muscle group filter
            let searchResultKeys = Set(searchResults.map { $0.key })
            results = results.filter { searchResultKeys.contains($0.key) }
            print("🔍 AddExerciseViewModel: Search for '\(query)' returned \(results.count) results after muscle group filter")
        }
        
        filtered = results
        print("🔍 AddExerciseViewModel: Final filtered count: \(filtered.count)")
        print("🔍 AddExerciseViewModel: Total archetypes in catalog: \(catalog.archetypes.count)")
        
        if filtered.isEmpty && (!query.isEmpty || !selectedMuscleGroup.isEmpty) {
            print("🔍 AddExerciseViewModel: No results found for query '\(query)' and muscle group '\(selectedMuscleGroup)'")
        }
    }
    

    
    private func updatePreviewName() {
        guard let archetype = selectedArchetype else {
            previewName = ""
            return
        }
        
        previewName = catalog.buildDisplayName(
            archetypeKey: archetype.key,
            attrs: selectedAttrs
        )
    }
    
    private func mapArchetypeToCategory(_ archetype: Archetype) -> ExerciseCategory {
        // Map archetype to the closest ExerciseCategory
        let key = archetype.key.lowercased()
        
        if key.contains("bench") || key.contains("push") || key.contains("chest") {
            return .barbell
        } else if key.contains("squat") || key.contains("deadlift") || key.contains("leg") {
            return .barbell
        } else if key.contains("row") || key.contains("pull") || key.contains("lat") {
            return .barbell
        } else if key.contains("curl") || key.contains("extension") {
            return .dumbbells
        } else if key.contains("press") || key.contains("raise") {
            return .barbell
        } else if key.contains("fly") {
            return .dumbbells
        } else if key.contains("crunch") || key.contains("plank") {
            return .bodyweight
        } else {
            return .barbell // Default fallback
        }
    }
}
