//
//  CircuitView.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct CircuitView: View {
    let circuit: Circuit
    let exercises: [Exercise]
    let onEdit: (() -> Void)?
    let onDelete: (() -> Void)?
    @Binding var workout: Workout
    @Environment(\.colorScheme) private var colorScheme
    @State private var isExpanded = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Circuit Header with accordion
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    // Edit button (moved to left)
                    if let onEdit = onEdit {
                        Button(action: onEdit) {
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Exercises list
                    Text(exercisesList)
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    
                    Spacer()
                    
                    // Expand/collapse arrow
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        .font(.caption)
                    
                    // Delete button
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.small)
            
            // Circuit Sets (only when expanded)
            if isExpanded {
                CircuitSetsView(circuit: circuit, exercises: exercises, workout: $workout)
            }
        }
    }
    
    // Computed properties for display
    private var exercisesList: String {
        let exerciseNames = exercises.map { exercise in
            let baseName = exercise.name
            let variants = exercise.variants.map { $0.displayName }.joined(separator: ", ")
            return variants.isEmpty ? baseName : "\(baseName) (\(variants))"
        }
        return exerciseNames.joined(separator: ", ")
    }
}

struct CircuitExerciseRow: View {
    let exercise: Exercise
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.caption2)
                .foregroundColor(.orange)
            
            Text(exercise.name)
                .font(.body)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
            
            if !exercise.variants.isEmpty {
                Text("(\(exercise.variants.map { $0.displayName }.joined(separator: ", ")))")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Spacer()
        }
    }
}

struct CircuitSetsView: View {
    let circuit: Circuit
    let exercises: [Exercise]
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingAddSet = false
    @Binding var workout: Workout
    
    var body: some View {
        VStack(spacing: 0) {
            // Show existing sets for the circuit
            ForEach(circuitSets, id: \.id) { circuitSet in
                let circuitExercises = workout.exercises.filter { $0.circuitId == circuit.id }
                CircuitSetRow(circuitSet: circuitSet, exercises: circuitExercises, workout: $workout)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            deleteCircuitSet(circuitSet)
                        } label: { Label("Delete", systemImage: "trash") }
                    }
            }
            
            // Add Set button
            Button {
                addCircuitSet()
            } label: {
                Label("Add Set", systemImage: "plus.circle")
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.small)
        }
    }
    
    // Helper computed property to get circuit sets
    private var circuitSets: [CircuitSet] {
        // Find exercises that belong to this circuit
        let circuitExercises = workout.exercises.filter { $0.circuitId == circuit.id }
        
        // For now, we'll use a simple approach: get sets from the first exercise
        // In a more sophisticated implementation, you might want to store circuit sets separately
        if let firstExercise = circuitExercises.first {
            return firstExercise.sets.enumerated().map { (index, set) in
                CircuitSet(
                    circuitId: circuit.id,
                    order: index, // Use index as order
                    restSec: set.restTime,
                    exercises: circuitExercises.map { ex in
                        CircuitSetExercise(exerciseId: ex.id, reps: set.reps, weight: set.weight)
                    }
                )
            }
        }
        return []
    }
    
    // Helper functions
    private func addCircuitSet() {
        let def = UserDefaults.standard.integer(forKey: "defaultRestTime")
        let rest = def == 0 ? 60 : def
        
        // Find exercises that belong to this circuit
        let circuitExercises = workout.exercises.filter { $0.circuitId == circuit.id }
        
        // Determine the next order for the new set
        let nextSetOrder = (circuitExercises.first?.sets.map { $0.order }.max() ?? -1) + 1
        
        // Add a set to each exercise in the circuit
        for exercise in circuitExercises {
            if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
                let newSet = ExerciseSet(
                    exerciseId: exercise.id,
                    reps: 10,
                    weight: 0,
                    restTime: rest,
                    order: nextSetOrder // Assign the new order
                )
                workout.exercises[index].sets.append(newSet)
            }
        }
    }
    
    private func deleteCircuitSet(_ circuitSet: CircuitSet) {
        // Find exercises that belong to this circuit
        let circuitExercises = workout.exercises.filter { $0.circuitId == circuit.id }
        
        // Remove the corresponding set from each exercise
        let setIndexToDelete = circuitSet.order
        for exercise in circuitExercises {
            if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }),
               setIndexToDelete < workout.exercises[index].sets.count {
                workout.exercises[index].sets.remove(at: setIndexToDelete)
                // Re-order subsequent sets
                for i in setIndexToDelete..<workout.exercises[index].sets.count {
                    workout.exercises[index].sets[i].order -= 1
                }
            }
        }
    }
}

struct CircuitSetRow: View {
    let circuitSet: CircuitSet
    let exercises: [Exercise]
    @Environment(\.colorScheme) private var colorScheme
    @Binding var workout: Workout
    
    var body: some View {
        VStack(spacing: 0) {
            // Set header
            HStack {
                Text("Set \(circuitSet.order + 1)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Spacer()
            }
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.small)
            
            // Exercise rows with editable sets
            ForEach(exercises, id: \.id) { exercise in
                let setIndex = circuitSet.order
                if setIndex < exercise.sets.count {
                    CircuitSetExerciseRow(
                        exercise: exercise,
                        set: $workout.exercises.first(where: { $0.id == exercise.id })!.sets[setIndex]
                    )
                    
                    // Separator line (except for last exercise)
                    if exercise.id != exercises.last?.id {
                        Divider()
                            .padding(.horizontal, DesignSystem.Spacing.medium)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .padding(.horizontal, DesignSystem.Spacing.medium)
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}

// MARK: - Circuit Set Exercise Row (similar to SetEditorRow)
struct CircuitSetExerciseRow: View {
    let exercise: Exercise
    @Binding var set: ExerciseSet
    @Environment(\.colorScheme) private var colorScheme
    
    private enum PickerType { case reps, weight, rest }
    @State private var showingPicker: Bool = false
    @State private var pickerType: PickerType = .rest
    @State private var tempReps: Int = 10
    @State private var tempWeight: Double = 0
    @State private var tempRest: Int = 60
    
    var body: some View {
        HStack(spacing: 12) {
            // Exercise name
            Text(exercise.name)
                .font(.body)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Inline text: reps x weight kg
            HStack(spacing: 6) {
                Button {
                    tempReps = set.reps
                    pickerType = .reps
                    showingPicker = true
                } label: {
                    Text("\(set.reps)")
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        .frame(minWidth: 32)
                }
                .buttonStyle(PlainButtonStyle())
                Text("reps")
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                Text("x")
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                Button {
                    tempWeight = set.weight
                    pickerType = .weight
                    showingPicker = true
                } label: {
                    Text(String(format: "%.1f", set.weight))
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        .frame(minWidth: 44)
                }
                .buttonStyle(PlainButtonStyle())
                Text("kg")
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            // Rest time picker
            Button {
                tempRest = set.restTime
                pickerType = .rest
                showingPicker = true
            } label: {
                HStack(spacing: 4) {
                    Text("\(set.restTime)")
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Text("s")
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                }
                .frame(minWidth: 44)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showingPicker) {
            NavigationView {
                VStack {
                    switch pickerType {
                    case .reps:
                        Picker("Reps", selection: $tempReps) {
                            ForEach(0...100, id: \.self) { v in
                                Text("\(v)").tag(v)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                    case .weight:
                        Picker("Weight", selection: $tempWeight) {
                            ForEach(Array(stride(from: 0.0, through: 300.0, by: 0.5)), id: \.self) { v in
                                Text(String(format: "%.1f kg", v)).tag(v)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                    case .rest:
                        Picker("Rest", selection: $tempRest) {
                            ForEach(Array(stride(from: 0, through: 600, by: 5)), id: \.self) { v in
                                Text("\(v) s").tag(v)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                    }
                }
                .navigationTitle(pickerType == .reps ? "Reps" : pickerType == .weight ? "Weight" : "Rest Time")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { showingPicker = false }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            switch pickerType {
                            case .reps:
                                set.reps = tempReps
                            case .weight:
                                set.weight = tempWeight
                            case .rest:
                                set.restTime = tempRest
                            }
                            showingPicker = false
                        }
                    }
                }
            }
            .presentationDetents([.fraction(0.35), .medium])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    let mockCircuit = Circuit(
        workoutId: "workout1",
        exerciseIds: ["ex1", "ex2", "ex3"],
        order: 0
    )
    
    let mockExercises = [
        Exercise(workoutId: "workout1", name: "Push-ups", category: .bodyweight, variants: [.wideGrip], isCircuit: true, circuitId: "circuit1"),
        Exercise(workoutId: "workout1", name: "Pull-ups", category: .bodyweight, variants: [.wideGrip], isCircuit: true, circuitId: "circuit1"),
        Exercise(workoutId: "workout1", name: "Dips", category: .bodyweight, variants: [], isCircuit: true, circuitId: "circuit1")
    ]
    
    return CircuitView(circuit: mockCircuit, exercises: mockExercises, onEdit: nil, onDelete: nil, workout: .constant(Workout(userId: "test", name: "Test Workout")))
        .padding()
        .background(Color(.systemBackground))
}
