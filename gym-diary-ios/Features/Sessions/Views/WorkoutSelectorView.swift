//
//  WorkoutSelectorView.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct WorkoutSelectorView: View {
    let onWorkoutSelected: (Workout) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var sessionManager = SessionManager.shared
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Search Bar
                    TextField("Search workouts", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, DesignSystem.Spacing.large)
                    
                    // Workouts List
                    if filteredWorkouts.isEmpty {
                        VStack(spacing: DesignSystem.Spacing.large) {
                            Image(systemName: "dumbbell")
                                .font(.system(size: 60))
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            Text("No Workouts Found")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("Create some workouts first to start training sessions")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: DesignSystem.Spacing.medium) {
                                ForEach(filteredWorkouts) { workout in
                                    WorkoutSelectionCard(workout: workout) {
                                        onWorkoutSelected(workout)
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.large)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Select Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .onAppear {
            // Workouts are loaded by SessionManager
        }
    }
    
    private var filteredWorkouts: [Workout] {
        if searchText.isEmpty {
            return sessionManager.workouts
        } else {
            return sessionManager.workouts.filter { workout in
                workout.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct WorkoutSelectionCard: View {
    let workout: Workout
    let onSelect: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: DesignSystem.Spacing.medium) {
                // Workout Icon
                Image(systemName: workout.iconName)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(getWorkoutColor())
                    )
                
                // Workout Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    
                    Text("\(workout.exercises.count + workout.circuits.count) exercises")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            .padding(DesignSystem.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getWorkoutColor() -> Color {
        switch workout.colorName.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "yellow": return .yellow
        default: return .blue
        }
    }
}

#Preview {
    WorkoutSelectorView { workout in
        print("Selected workout: \(workout.name)")
    }
    .preferredColorScheme(.dark)
}
