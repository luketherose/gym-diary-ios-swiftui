import SwiftUI

// MARK: - Workout Card Component
struct WorkoutCardView: View {
    @Binding var workout: Workout
    let sections: [WorkoutSection]
    var onDelete: (() -> Void)? = nil
    var isDragging: Bool = false
    @State private var showingWorkoutDetails = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Activity ring gray color (dark gray with reddish undertone)
    private var activityRingGray: Color {
        Color(red: 0.15, green: 0.12, blue: 0.14) // Dark gray with reddish tint
    }
    
    // Get first few exercises for preview
    private var exercisePreview: [String] {
        // For now, just show exercise names from the main exercises array
        // TODO: Add support for circuit exercises when the data structure is clear
        return Array(workout.exercises.prefix(3)).map { $0.name }
    }
    
    var body: some View {
        Button(action: {
            showingWorkoutDetails = true
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Header with title and exercise count
                HStack {
                    Text(workout.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    // Exercise count badge
                    Text("\(workout.exercises.count + workout.circuits.count)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.8))
                        )
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.top, DesignSystem.Spacing.large)
                .padding(.bottom, DesignSystem.Spacing.medium)
                
                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                // Exercise preview
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    ForEach(exercisePreview, id: \.self) { exerciseName in
                        Text(exerciseName)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(1)
                    }
                    
                    // Show "..." if there are more exercises
                    if workout.exercises.count + workout.circuits.count > 3 {
                        Text("...")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.top, DesignSystem.Spacing.medium)
                .padding(.bottom, DesignSystem.Spacing.large)
            }
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(activityRingGray)
            )
            .shadow(
                color: Color.black.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
            .opacity(isDragging ? 0.6 : 1.0)
            .scaleEffect(isDragging ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isDragging)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingWorkoutDetails) {
            WorkoutDetailView(workout: $workout, sections: sections, onDelete: {
                onDelete?()
                showingWorkoutDetails = false
            }, onDismiss: {
                showingWorkoutDetails = false
            })
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        WorkoutCardView(
            workout: .constant(Workout(
                userId: "user123",
                name: "Push Day",
                exercises: [
                    Exercise(
                        workoutId: "workout1",
                        name: "Bench Press",
                        category: .barbell,
                        sets: [
                            ExerciseSet(exerciseId: "ex1", reps: 10, weight: 80),
                            ExerciseSet(exerciseId: "ex1", reps: 10, weight: 80),
                            ExerciseSet(exerciseId: "ex1", reps: 10, weight: 80)
                        ]
                    ),
                    Exercise(
                        workoutId: "workout1",
                        name: "Incline Press",
                        category: .barbell,
                        sets: [
                            ExerciseSet(exerciseId: "ex2", reps: 12, weight: 60),
                            ExerciseSet(exerciseId: "ex2", reps: 12, weight: 60),
                            ExerciseSet(exerciseId: "ex2", reps: 12, weight: 60)
                        ]
                    ),
                    Exercise(
                        workoutId: "workout1",
                        name: "Dips",
                        category: .bodyweight,
                        sets: [
                            ExerciseSet(exerciseId: "ex3", reps: 15, weight: 0),
                            ExerciseSet(exerciseId: "ex3", reps: 15, weight: 0),
                            ExerciseSet(exerciseId: "ex3", reps: 15, weight: 0)
                        ]
                    )
                ],
                circuits: [],
                sectionId: "section1",
                iconName: "dumbbell",
                colorName: "Blue"
            )),
            sections: []
        )
        .padding()
    }
}
