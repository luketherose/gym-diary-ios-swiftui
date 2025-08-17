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
    @Environment(\.colorScheme) private var colorScheme
    @State private var isExpanded = true
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            // Circuit Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.title3)
                        .foregroundColor(.orange)
                        .frame(width: 24, height: 24)
                    
                    Text("Circuit")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    
                    Text("(\(circuit.exerciseIds.count) exercises)")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
                .padding(.vertical, DesignSystem.Spacing.small)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                // Circuit Exercises
                VStack(spacing: DesignSystem.Spacing.small) {
                    ForEach(circuit.exerciseIds, id: \.self) { exerciseId in
                        if let exercise = exercises.first(where: { $0.id == exerciseId }) {
                            CircuitExerciseRow(exercise: exercise)
                        }
                    }
                }
                .padding(.leading, DesignSystem.Spacing.medium)
                
                // Circuit Sets
                CircuitSetsView(circuit: circuit, exercises: exercises)
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
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
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            // Header
            HStack {
                Text("Sets")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Spacer()
                
                Button(action: {
                    showingAddSet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.orange)
                }
            }
            
            // Sets List
            if circuit.exerciseIds.isEmpty {
                Text("No exercises in circuit")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .padding(.vertical, DesignSystem.Spacing.medium)
            } else {
                // Placeholder for circuit sets
                Text("Circuit sets will be implemented here")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .padding(.vertical, DesignSystem.Spacing.medium)
            }
        }
        .padding(.top, DesignSystem.Spacing.small)
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
    
    return CircuitView(circuit: mockCircuit, exercises: mockExercises)
        .padding()
        .background(Color(.systemBackground))
}
