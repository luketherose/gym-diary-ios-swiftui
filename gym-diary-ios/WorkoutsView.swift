import SwiftUI
import UniformTypeIdentifiers

// MARK: - Workouts View
struct WorkoutsView: View {
    @State private var sections: [WorkoutSection] = [
        WorkoutSection(userId: "user123", name: "Push/Pull/Legs", workouts: [
            Workout(userId: "user123", name: "Push Day", exercises: [
                Exercise(workoutId: "workout1", name: "Bench Press", category: .barbell, sets: [
                    ExerciseSet(exerciseId: "exercise1", reps: 8, weight: 80),
                    ExerciseSet(exerciseId: "exercise1", reps: 8, weight: 80),
                    ExerciseSet(exerciseId: "exercise1", reps: 6, weight: 85)
                ]),
                Exercise(workoutId: "workout1", name: "Overhead Press", category: .barbell, sets: [
                    ExerciseSet(exerciseId: "exercise2", reps: 10, weight: 50),
                    ExerciseSet(exerciseId: "exercise2", reps: 10, weight: 50),
                    ExerciseSet(exerciseId: "exercise2", reps: 8, weight: 55)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -2, to: Date()), sectionId: "section1", iconName: "figure.strengthtraining.traditional", colorName: "Red", chipText: "Push"),
            Workout(userId: "user123", name: "Pull Day", exercises: [
                Exercise(workoutId: "workout2", name: "Deadlift", category: .barbell, sets: [
                    ExerciseSet(exerciseId: "exercise3", reps: 5, weight: 120),
                    ExerciseSet(exerciseId: "exercise3", reps: 5, weight: 120),
                    ExerciseSet(exerciseId: "exercise3", reps: 3, weight: 140)
                ]),
                Exercise(workoutId: "workout2", name: "Pull-ups", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise4", reps: 8, weight: 0),
                    ExerciseSet(exerciseId: "exercise4", reps: 6, weight: 0),
                    ExerciseSet(exerciseId: "exercise4", reps: 6, weight: 0)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -2, to: Date()), sectionId: "section1", iconName: "figure.strengthtraining.traditional", colorName: "Blue", chipText: "Pull"),
            Workout(userId: "user123", name: "Legs Day", exercises: [
                Exercise(workoutId: "workout3", name: "Squat", category: .barbell, sets: [
                    ExerciseSet(exerciseId: "exercise5", reps: 8, weight: 100),
                    ExerciseSet(exerciseId: "exercise5", reps: 8, weight: 100),
                    ExerciseSet(exerciseId: "exercise5", reps: 6, weight: 110)
                ]),
                Exercise(workoutId: "workout3", name: "Romanian Deadlift", category: .barbell, sets: [
                    ExerciseSet(exerciseId: "exercise6", reps: 10, weight: 80),
                    ExerciseSet(exerciseId: "exercise6", reps: 10, weight: 80),
                    ExerciseSet(exerciseId: "exercise6", reps: 8, weight: 85)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -8, to: Date()), sectionId: "section1", iconName: "figure.strengthtraining.traditional", colorName: "Green", chipText: "Legs")
        ]),
        WorkoutSection(userId: "user123", name: "Upper Body", workouts: [
            Workout(userId: "user123", name: "Upper Body Circuit", exercises: [
                Exercise(workoutId: "workout4", name: "Push-ups", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise7", reps: 15, weight: 0),
                    ExerciseSet(exerciseId: "exercise7", reps: 12, weight: 0),
                    ExerciseSet(exerciseId: "exercise7", reps: 10, weight: 0)
                ]),
                Exercise(workoutId: "workout4", name: "Dips", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise8", reps: 10, weight: 0),
                    ExerciseSet(exerciseId: "exercise8", reps: 8, weight: 0),
                    ExerciseSet(exerciseId: "exercise8", reps: 6, weight: 0)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -1, to: Date()), sectionId: "section2", iconName: "figure.strengthtraining.functional", colorName: "Orange", chipText: "Upper")
        ]),
        WorkoutSection(userId: "user123", name: "Cardio", workouts: [
            Workout(userId: "user123", name: "HIIT Cardio", exercises: [
                Exercise(workoutId: "workout5", name: "Burpees", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise9", reps: 20, weight: 0),
                    ExerciseSet(exerciseId: "exercise9", reps: 20, weight: 0),
                    ExerciseSet(exerciseId: "exercise9", reps: 20, weight: 0)
                ]),
                Exercise(workoutId: "workout5", name: "Mountain Climbers", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise10", reps: 25, weight: 0),
                    ExerciseSet(exerciseId: "exercise10", reps: 25, weight: 0),
                    ExerciseSet(exerciseId: "exercise10", reps: 25, weight: 0)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -3, to: Date()), sectionId: "section3", iconName: "figure.run", colorName: "Purple", chipText: "Cardio")
        ])
    ]
    
    @State private var showingCreateWorkout = false
    @State private var showingAddSection = false
    @State private var newSectionName = ""
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Workouts")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddSection = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                    }
                    .padding(DesignSystem.Spacing.large)
                    
                    // Sections List
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.large) {
                            ForEach(sections.indices, id: \.self) { sectionIndex in
                                WorkoutSectionView(
                                    section: $sections[sectionIndex],
                                    onWorkoutMoved: { fromIndex, toIndex in
                                        moveWorkout(from: fromIndex, to: toIndex, in: sectionIndex)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.bottom, DesignSystem.Spacing.large)
                    }
                }
            }
            .sheet(isPresented: $showingCreateWorkout) {
                CreateWorkoutView(sections: $sections)
            }
            .alert("Add New Section", isPresented: $showingAddSection) {
                TextField("Section name", text: $newSectionName)
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    addNewSection()
                }
            }
        }
    }
    
    private func moveWorkout(from fromIndex: Int, to toIndex: Int, in sectionIndex: Int) {
        let workout = sections[sectionIndex].workouts.remove(at: fromIndex)
        sections[sectionIndex].workouts.insert(workout, at: toIndex)
    }
    
    private func addNewSection() {
        guard !newSectionName.isEmpty else { return }
        
        let newSection = WorkoutSection(
            userId: "user123",
            name: newSectionName,
            workouts: []
        )
        
        sections.append(newSection)
        newSectionName = ""
    }
}

// MARK: - Workout Section View
struct WorkoutSectionView: View {
    @Binding var section: WorkoutSection
    let onWorkoutMoved: (Int, Int) -> Void
    
    @State private var showingCreateWorkout = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            // Section Header
            HStack {
                Text(section.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Spacer()
                
                                        Button(action: {
                            showingCreateWorkout = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title3)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
            }
            
            // Workouts Grid
            if section.workouts.isEmpty {
                EmptyWorkoutSectionView()
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DesignSystem.Spacing.medium), count: 2), spacing: DesignSystem.Spacing.medium) {
                    ForEach(section.workouts.indices, id: \.self) { workoutIndex in
                        WorkoutCard(workout: section.workouts[workoutIndex])
                            .onDrag {
                                NSItemProvider(object: "\(workoutIndex)" as NSString)
                            }
                            .onDrop(of: [.text], delegate: WorkoutDropDelegate(
                                workoutIndex: workoutIndex,
                                section: $section,
                                onWorkoutMoved: onWorkoutMoved
                            ))
                    }
                }
            }
        }
        .padding(DesignSystem.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
        )
        .sheet(isPresented: $showingCreateWorkout) {
            CreateWorkoutView(sections: .constant([section]))
        }
    }
}

// MARK: - Empty Workout Section View
struct EmptyWorkoutSectionView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            Image(systemName: "dumbbell")
                .font(.system(size: 40))
                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            
            Text("No workouts yet")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            
            Text("Tap the + button to create your first workout")
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(DesignSystem.Colors.background(for: colorScheme))
        )
    }
}

// MARK: - Workout Drop Delegate
struct WorkoutDropDelegate: DropDelegate {
    let workoutIndex: Int
    @Binding var section: WorkoutSection
    let onWorkoutMoved: (Int, Int) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else { return false }
        
        itemProvider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, error) in
            DispatchQueue.main.async {
                if let data = data as? Data,
                   let sourceIndexString = String(data: data, encoding: .utf8),
                   let sourceIndex = Int(sourceIndexString) {
                    onWorkoutMoved(sourceIndex, workoutIndex)
                }
            }
        }
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

// MARK: - Workout Icon and Color Selector
struct WorkoutIconColorSelector: View {
    @Binding var selectedIcon: WorkoutIcon
    @Binding var selectedColor: WorkoutColor
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedCategory = "Strength"
    
    private let categories = ["Strength", "Cardio", "Mobility", "Sports", "General"]
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // Category Picker
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Category")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedCategory) { oldValue, newValue in
                    // Update selected icon to first icon in new category
                    if let firstIcon = WorkoutIcon.icons(for: newValue).first {
                        selectedIcon = firstIcon
                    }
                }
            }
            
            // Icon Selection
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Icon")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: DesignSystem.Spacing.medium) {
                    ForEach(WorkoutIcon.icons(for: selectedCategory), id: \.systemName) { icon in
                        Button(action: {
                            selectedIcon = icon
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: icon.systemName)
                                    .font(.title2)
                                    .foregroundColor(selectedIcon.systemName == icon.systemName ? .white : selectedColor.color)
                                    .frame(width: 40, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .fill(selectedIcon.systemName == icon.systemName ? selectedColor.color : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                    .stroke(selectedColor.color, lineWidth: selectedIcon.systemName == icon.systemName ? 0 : 2)
                                            )
                                    )
                                
                                Text(icon.displayName)
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // Color Selection
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Color")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: DesignSystem.Spacing.medium) {
                    ForEach(WorkoutColor.allColors, id: \.name) { color in
                        Button(action: {
                            selectedColor = color
                        }) {
                            VStack(spacing: 4) {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: selectedColor.name == color.name ? 3 : 0)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black.opacity(0.2), lineWidth: selectedColor.name == color.name ? 0 : 1)
                                    )
                                
                                Text(color.name)
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                    .lineLimit(1)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

// MARK: - Create Workout View
struct CreateWorkoutView: View {
    @Binding var sections: [WorkoutSection]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
                @State private var workoutName = ""
            @State private var selectedSectionIndex = 0
            @State private var selectedIcon = WorkoutIcon.randomIcon()
            @State private var selectedColor = WorkoutColor.randomColor()
            @State private var chipText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Spacer()
                        
                        Text("Create Workout")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Button("Create") {
                            createWorkout()
                        }
                        .foregroundColor(DesignSystem.Colors.primary)
                        .disabled(workoutName.isEmpty)
                    }
                    .padding(DesignSystem.Spacing.large)
                    
                    // Form
                    ScrollView {
                        VStack(spacing: DesignSystem.Spacing.large) {
                            // Form fields
                            VStack(spacing: DesignSystem.Spacing.medium) {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                    Text("Workout Name")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                    
                                    TextField("Enter workout name", text: $workoutName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                    Text("Section")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                    
                                    Picker("Section", selection: $selectedSectionIndex) {
                                        ForEach(sections.indices, id: \.self) { index in
                                            Text(sections[index].name).tag(index)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                    )
                                }
                                
                                                                        // Icon and Color Selection
                                        WorkoutIconColorSelector(
                                            selectedIcon: $selectedIcon,
                                            selectedColor: $selectedColor
                                        )
                                        
                                        // Chip Text Input
                                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                            Text("Chip Text")
                                                .font(.headline)
                                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                            
                                            TextField("e.g., Push, Pull, Legs, Upper, Lower...", text: $chipText)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .background(
                                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                                )
                                        }
                            }
                        }
                        .padding(DesignSystem.Spacing.large)
                    }
                }
            }
        }
    }
    
                private func createWorkout() {
                let newWorkout = Workout(
                    userId: "user123",
                    name: workoutName,
                    sectionId: sections[selectedSectionIndex].id,
                    iconName: selectedIcon.systemName,
                    colorName: selectedColor.name,
                    chipText: chipText.isEmpty ? "New" : chipText
                )
                sections[selectedSectionIndex].workouts.append(newWorkout)
                dismiss()
            }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    let workout: Workout
    @State private var showingWorkoutDetails = false
    @Environment(\.colorScheme) private var colorScheme
    
    private var workoutIcon: WorkoutIcon {
        WorkoutIcon.allIcons.first { $0.systemName == workout.iconName } ?? WorkoutIcon.randomIcon()
    }
    
    private var workoutColor: WorkoutColor {
        WorkoutColor.allColors.first { $0.name == workout.colorName } ?? WorkoutColor.randomColor()
    }
    
    var body: some View {
        Button(action: {
            showingWorkoutDetails = true
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Header with icon and gradient background
                HStack {
                    Image(systemName: workoutIcon.systemName)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(workoutColor.color)
                        )
                    
                    Spacer()
                    
                    // Custom chip text badge
                    GradientBadge(
                        text: workout.chipText.isEmpty ? "\(workout.exercises.count)" : workout.chipText,
                        gradient: LinearGradient(colors: [workoutColor.color, workoutColor.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.top, DesignSystem.Spacing.large)
                .padding(.bottom, DesignSystem.Spacing.medium)
                
                // Content area
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text(workout.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        .lineLimit(2)
                    
                    HStack {
                        if let lastExecuted = workout.lastExecuted {
                            Text("Last: \(lastExecuted, style: .date)")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        } else {
                            Text("Never executed")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                        
                        Spacer()
                        
                        // Small indicator for workout type
                        GradientBadge(
                            text: workout.exercises.count > 0 ? workoutIcon.displayName : "Empty",
                            gradient: LinearGradient(colors: [workoutColor.color, workoutColor.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.bottom, DesignSystem.Spacing.large)
            }
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                            .fill(workoutColor.color)
                            .mask(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.8), Color.clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .opacity(colorScheme == .dark ? 0.15 : 0.08)
                    )
            )
            .shadow(
                color: DesignSystem.Shadows.adaptive(for: colorScheme).color,
                radius: DesignSystem.Shadows.adaptive(for: colorScheme).radius,
                x: DesignSystem.Shadows.adaptive(for: colorScheme).x,
                y: DesignSystem.Shadows.adaptive(for: colorScheme).y
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingWorkoutDetails) {
            WorkoutDetailView(workout: workout)
        }
    }
}

// MARK: - Workout Detail View
struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private var workoutIcon: WorkoutIcon {
        WorkoutIcon.allIcons.first { $0.systemName == workout.iconName } ?? WorkoutIcon.randomIcon()
    }
    
    private var workoutColor: WorkoutColor {
        WorkoutColor.allColors.first { $0.name == workout.colorName } ?? WorkoutColor.randomColor()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Header
                    HStack {
                        Image(systemName: workoutIcon.systemName)
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(workoutColor.color)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workout.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("\(workout.exercises.count) exercises")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                        
                        Spacer()
                        
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    }
                    .padding(DesignSystem.Spacing.large)
                    
                    // Exercises List
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.medium) {
                            ForEach(workout.exercises) { exercise in
                                CardContainer {
                                    ExerciseDetailRow(exercise: exercise)
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                    }
                    
                    // Start Workout Button
                    GradientButton(
                        title: "Start Workout",
                        gradient: LinearGradient(colors: [workoutColor.color, workoutColor.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    ) {
                        // Start workout action
                        dismiss()
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.bottom, DesignSystem.Spacing.large)
                }
            }
        }
    }
}

// MARK: - Exercise Detail Row
struct ExerciseDetailRow: View {
    let exercise: Exercise
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack {
                GradientIcon(
                    systemName: "dumbbell.fill",
                    gradient: DesignSystem.Gradients.primary,
                    size: 20
                )
                
                Text(exercise.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Spacer()
                
                GradientBadge(
                    text: "\(exercise.sets.count) sets",
                    gradient: DesignSystem.Gradients.primary
                )
            }
            
            // Sets
            VStack(spacing: DesignSystem.Spacing.small) {
                ForEach(exercise.sets.indices, id: \.self) { index in
                    let set = exercise.sets[index]
                    HStack {
                        Text("Set \(index + 1)")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Spacer()
                        
                        Text("\(set.reps) reps")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        if set.weight > 0 {
                            Text("\(set.weight, specifier: "%.1f") kg")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.small)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.small)
                            .fill(DesignSystem.Colors.background(for: colorScheme))
                    )
                }
            }
        }
    }
}
