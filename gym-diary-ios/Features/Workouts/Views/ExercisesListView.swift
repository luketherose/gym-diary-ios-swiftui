import SwiftUI

struct ExercisesListView: View {
    @Binding var workout: Workout
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingAddExercise = false
    @State private var editingExerciseIndex: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            exercisesList
        }
        .sheet(isPresented: $showingAddExercise) { addExerciseSheet }
        .sheet(isPresented: Binding<Bool>(
            get: { editingExerciseIndex != nil },
            set: { if !$0 { editingExerciseIndex = nil } }
        )) { editExerciseSheet }
    }

    private var addExerciseSheet: some View {
        AddExerciseView { newExercise in
            workout.exercises.append(newExercise)
        }
    }

    private var exercisesList: some View {
        List {
            ForEach(Array(workout.exercises.enumerated()), id: \.offset) { tuple in
                let eIdx = tuple.offset
                exerciseSection(for: eIdx)
            }
            addExerciseSection
        }
        .listStyle(.insetGrouped)
    }

    private func exerciseSection(for eIdx: Int) -> some View {
        Section {
            ForEach(Array(workout.exercises[eIdx].sets.enumerated()), id: \.offset) { sTuple in
                let sIdx = sTuple.offset
                SetEditorRow(set: $workout.exercises[eIdx].sets[sIdx])
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            workout.exercises[eIdx].sets.remove(at: sIdx)
                        } label: { Label("Delete", systemImage: "trash") }
                    }
            }
            Button {
                let def = UserDefaults.standard.integer(forKey: "defaultRestTime")
                let rest = def == 0 ? 60 : def
                workout.exercises[eIdx].sets.append(
                    ExerciseSet(
                        exerciseId: workout.exercises[eIdx].id,
                        reps: 10,
                        weight: 0,
                        restTime: rest
                    )
                )
            } label: {
                Label("Add Set", systemImage: "plus.circle")
            }
        } header: {
            HStack(spacing: 8) {
                let ex = workout.exercises[eIdx]
                Text(ex.variants.isEmpty ? ex.name : "\(ex.name) (\(ex.variants.map { $0.displayName }.joined(separator: ", "))) ")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                Spacer()
                Button {
                    editingExerciseIndex = eIdx
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                Button {
                    workout.exercises.remove(at: eIdx)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }

    private func allowedVariants(for exercise: Exercise) -> [ExerciseVariant] {
        switch exercise.name {
        case "Bench Press": return [.flat, .incline, .decline, .wideGrip, .closeGrip, .reverseGrip]
        case "Incline Bench Press": return [.incline, .wideGrip, .closeGrip]
        case "Overhead Press": return [.standing, .seated, .pushPress]
        case "Squat": return [.front, .backHighbar, .backLowbar, .pause, .box, .goblet, .safetyBar]
        case "Deadlift": return [.conventional, .sumo, .rdl, .stiffLeg, .trapBar]
        case "Barbell Row": return [.wideGrip, .closeGrip, .reverseGrip, .neutralGrip]
        case "Lat Pulldown": return [.wideGrip, .closeGrip, .neutralGrip, .reverseGrip]
        case "Bicep Curl": return [.ezBar, .preacher, .seated, .standing]
        case "Tricep Pushdown": return [.rope, .cable, .reverseGrip]
        case "Leg Press": return [.pause]
        default: return ExerciseVariant.allCases
        }
    }

    private var addExerciseSection: some View {
        Section {
            HStack {
                Spacer()
                Button { showingAddExercise = true } label: {
                    Label("Add Exercise", systemImage: "plus.circle.fill")
                }
                Spacer()
            }
        }
    }

    // Edit sheet
    @ViewBuilder
    private var editExerciseSheet: some View {
        if let idx = editingExerciseIndex, idx < workout.exercises.count {
            AddExerciseView(exercise: $workout.exercises[idx])
        }
    }
}


