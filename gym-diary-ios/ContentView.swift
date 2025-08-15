//
//  ContentView.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isDarkTheme = false
    
    var body: some View {
        TabView {
            WorkoutView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workout")
                }
            
            ProfileView(isDarkTheme: $isDarkTheme)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue)
        .preferredColorScheme(isDarkTheme ? .dark : .light)
    }
}

// MARK: - Workout View
struct WorkoutView: View {
    @State private var sections: [WorkoutSection] = [
        WorkoutSection(userId: "user123", name: "Push Pull Legs", workouts: [
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
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -2, to: Date()), sectionId: "section1", iconName: "figure.strengthtraining.traditional", colorName: "Red"),
            Workout(userId: "user123", name: "Pull Day", exercises: [
                Exercise(workoutId: "workout2", name: "Deadlift", category: .barbell, sets: [
                    ExerciseSet(exerciseId: "exercise3", reps: 5, weight: 120),
                    ExerciseSet(exerciseId: "exercise3", reps: 5, weight: 120),
                    ExerciseSet(exerciseId: "exercise3", reps: 5, weight: 120)
                ]),
                Exercise(workoutId: "workout2", name: "Pull-ups", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise4", reps: 8, weight: 0),
                    ExerciseSet(exerciseId: "exercise4", reps: 8, weight: 0),
                    ExerciseSet(exerciseId: "exercise4", reps: 6, weight: 0)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -5, to: Date()), sectionId: "section1", iconName: "figure.strengthtraining.traditional", colorName: "Blue"),
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
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -8, to: Date()), sectionId: "section1", iconName: "figure.strengthtraining.traditional", colorName: "Green")
        ]),
        WorkoutSection(userId: "user123", name: "Upper Body", workouts: [
            Workout(userId: "user123", name: "Chest & Triceps", exercises: [
                Exercise(workoutId: "workout4", name: "Incline Bench Press", category: .barbell, sets: [
                    ExerciseSet(exerciseId: "exercise7", reps: 10, weight: 70),
                    ExerciseSet(exerciseId: "exercise7", reps: 10, weight: 70),
                    ExerciseSet(exerciseId: "exercise7", reps: 8, weight: 75)
                ]),
                Exercise(workoutId: "workout4", name: "Dips", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise8", reps: 12, weight: 0),
                    ExerciseSet(exerciseId: "exercise8", reps: 12, weight: 0),
                    ExerciseSet(exerciseId: "exercise8", reps: 10, weight: 0)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -1, to: Date()), sectionId: "section2", iconName: "figure.strengthtraining.functional", colorName: "Orange")
        ]),
        WorkoutSection(userId: "user123", name: "Cardio", workouts: [
            Workout(userId: "user123", name: "HIIT Training", exercises: [
                Exercise(workoutId: "workout5", name: "Burpees", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise9", reps: 20, weight: 0),
                    ExerciseSet(exerciseId: "exercise9", reps: 20, weight: 0),
                    ExerciseSet(exerciseId: "exercise9", reps: 15, weight: 0)
                ]),
                Exercise(workoutId: "workout5", name: "Mountain Climbers", category: .bodyweight, sets: [
                    ExerciseSet(exerciseId: "exercise10", reps: 30, weight: 0),
                    ExerciseSet(exerciseId: "exercise10", reps: 30, weight: 0),
                    ExerciseSet(exerciseId: "exercise10", reps: 25, weight: 0)
                ])
            ], lastExecuted: Calendar.current.date(byAdding: .day, value: -3, to: Date()), sectionId: "section3", iconName: "figure.run", colorName: "Purple")
        ])
    ]
    
    @State private var showingCreateWorkout = false
    @State private var showingCreateSection = false
    @State private var draggedWorkout: Workout?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sections.indices, id: \.self) { sectionIndex in
                    Section {
                        DisclosureGroup(
                            isExpanded: $sections[sectionIndex].isExpanded,
                                                               content: {
                                       LazyVStack(spacing: 12) {
                                           ForEach(sections[sectionIndex].workouts) { workout in
                                               WorkoutCard(workout: workout)
                                                   .onDrag {
                                                       self.draggedWorkout = workout
                                                       return NSItemProvider(object: workout.id as NSString)
                                                   }
                                                   .onDrop(of: [.text], delegate: WorkoutDropDelegate(
                                                       workout: workout,
                                                       sections: $sections,
                                                       draggedWorkout: $draggedWorkout,
                                                       currentSectionIndex: sectionIndex
                                                   ))
                                           }
                                       }
                                .padding(.top, 8)
                            },
                            label: {
                                HStack {
                                    Text(sections[sectionIndex].name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text("\(sections[sectionIndex].workouts.count) workouts")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                    }
                }
            }
            .navigationTitle("Workouts")
            .navigationBarItems(
                leading: Button(action: {
                    showingCreateSection = true
                }) {
                    Image(systemName: "folder.badge.plus")
                },
                trailing: Button(action: {
                    showingCreateWorkout = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingCreateWorkout) {
                CreateWorkoutView(sections: $sections)
            }
            .sheet(isPresented: $showingCreateSection) {
                CreateSectionView(sections: $sections)
            }
        }
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
                    
                    // Exercise count badge
                    GradientBadge(
                        text: "\(workout.exercises.count)",
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
            
            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, set in
                HStack {
                    Text("Set \(index + 1)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    
                    Spacer()
                    
                    HStack(spacing: DesignSystem.Spacing.small) {
                        Text("\(set.reps) reps")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        if set.weight > 0 {
                            Text("•")
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            Text("\(Int(set.weight)) kg")
                                .font(.subheadline)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                    }
                }
                .padding(.leading, 28)
                .padding(.vertical, 2)
            }
        }
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
                .onChange(of: selectedCategory) { _ in
                    // Update selected icon to first icon in new category
                    if let firstIcon = WorkoutIcon.icons(for: selectedCategory).first {
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
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    ModalContainer {
                        VStack(spacing: DesignSystem.Spacing.large) {
                            // Header
                            HStack {
                                GradientIcon(
                                    systemName: "plus.circle.fill",
                                    gradient: DesignSystem.Gradients.primary,
                                    size: 32
                                )
                                
                                Text("New Workout")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Spacer()
                            }
                            
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
                            }
                            
                            // Info text
                            HStack {
                                GradientIcon(
                                    systemName: "info.circle.fill",
                                    gradient: DesignSystem.Gradients.warning,
                                    size: 16
                                )
                                
                                Text("You can add exercises after creating the workout")
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                
                                Spacer()
                            }
                            
                            // Buttons
                            HStack(spacing: DesignSystem.Spacing.medium) {
                                Button("Cancel") {
                                    dismiss()
                                }
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .padding(.horizontal, DesignSystem.Spacing.large)
                                .padding(.vertical, DesignSystem.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                                
                                GradientButton(
                                    title: "Create",
                                    gradient: DesignSystem.Gradients.primary,
                                    isEnabled: !workoutName.isEmpty
                                ) {
                                    let newWorkout = Workout(
                                        userId: "user123",
                                        name: workoutName,
                                        sectionId: sections[selectedSectionIndex].id,
                                        iconName: selectedIcon.systemName,
                                        colorName: selectedColor.name
                                    )
                                    sections[selectedSectionIndex].workouts.append(newWorkout)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
                .padding(DesignSystem.Spacing.large)
            }
        }
    }
}

// MARK: - Create Section View
struct CreateSectionView: View {
    @Binding var sections: [WorkoutSection]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var sectionName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    ModalContainer {
                        VStack(spacing: DesignSystem.Spacing.large) {
                            // Header
                            HStack {
                                GradientIcon(
                                    systemName: "folder.badge.plus",
                                    gradient: DesignSystem.Gradients.secondary,
                                    size: 32
                                )
                                
                                Text("New Section")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Spacer()
                            }
                            
                            // Form fields
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("Section Name")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                TextField("Enter section name", text: $sectionName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                    )
                            }
                            
                            // Info text
                            HStack {
                                GradientIcon(
                                    systemName: "info.circle.fill",
                                    gradient: DesignSystem.Gradients.warning,
                                    size: 16
                                )
                                
                                Text("Create a new section to organize your workouts")
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                
                                Spacer()
                            }
                            
                            // Buttons
                            HStack(spacing: DesignSystem.Spacing.medium) {
                                Button("Cancel") {
                                    dismiss()
                                }
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .padding(.horizontal, DesignSystem.Spacing.large)
                                .padding(.vertical, DesignSystem.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                                
                                GradientButton(
                                    title: "Create",
                                    gradient: DesignSystem.Gradients.secondary,
                                    isEnabled: !sectionName.isEmpty
                                ) {
                                    let newSection = WorkoutSection(userId: "user123", name: sectionName)
                                    sections.append(newSection)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
                .padding(DesignSystem.Spacing.large)
            }
        }
    }
}

// MARK: - Drop Delegate
struct WorkoutDropDelegate: DropDelegate {
    let workout: Workout
    @Binding var sections: [WorkoutSection]
    @Binding var draggedWorkout: Workout?
    let currentSectionIndex: Int
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedWorkout = draggedWorkout else { return false }
        
        // Find the source section
        var sourceSectionIndex: Int?
        var sourceWorkoutIndex: Int?
        
        for (sectionIndex, section) in sections.enumerated() {
            if let workoutIndex = section.workouts.firstIndex(where: { $0.id == draggedWorkout.id }) {
                sourceSectionIndex = sectionIndex
                sourceWorkoutIndex = workoutIndex
                break
            }
        }
        
        guard let sourceSectionIndex = sourceSectionIndex,
              let sourceWorkoutIndex = sourceWorkoutIndex else { return false }
        
        // Remove from source section
        let movedWorkout = sections[sourceSectionIndex].workouts.remove(at: sourceWorkoutIndex)
        
        // Add to target section
        sections[currentSectionIndex].workouts.append(movedWorkout)
        
        self.draggedWorkout = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

// MARK: - Profile View (unchanged)
struct ProfileView: View {
    @Binding var isDarkTheme: Bool
    @State private var timerNotificationsEnabled = true
    @State private var soundsEnabled = true
    @State private var useKilograms = true
    @State private var defaultRestTime = 60
    @State private var showingRestTimePicker = false
    @State private var showingPersonalInfo = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Array of rest time options (0 to 300 seconds)
    private let restTimeOptions = Array(0...300)
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        // Account Section
                        ProfileAccountSection(showingPersonalInfo: $showingPersonalInfo)
                
                        // General Settings Section
                        ProfileGeneralSection(
                            isDarkTheme: $isDarkTheme,
                            useKilograms: $useKilograms,
                            defaultRestTime: $defaultRestTime,
                            showingRestTimePicker: $showingRestTimePicker
                        )
                
                        // Notifications Section
                        ProfileNotificationsSection(
                            timerNotificationsEnabled: $timerNotificationsEnabled,
                            soundsEnabled: $soundsEnabled
                        )
                
                        // Information Section
                        ProfileInformationSection()
                        
                        // Version Section
                        ProfileVersionSection()
                    }
                    .padding(DesignSystem.Spacing.large)
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingRestTimePicker) {
                RestTimePickerView(
                    selectedTime: $defaultRestTime,
                    isPresented: $showingRestTimePicker
                )
            }
            .sheet(isPresented: $showingPersonalInfo) {
                PersonalInfoView()
            }
        }
    }
}

// MARK: - Profile Section Components
struct ProfileAccountSection: View {
    @Binding var showingPersonalInfo: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            Button(action: {
                showingPersonalInfo = true
            }) {
                HStack {
                    GradientIcon(
                        systemName: "person.circle.fill",
                        gradient: DesignSystem.Gradients.primary,
                        size: 50
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("User Name")
                            .font(.headline)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        Text("user@email.com")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    }
                    
                    Spacer()
                    
                    GradientIcon(
                        systemName: "chevron.right",
                        gradient: DesignSystem.Gradients.primary,
                        size: 16
                    )
                }
                .padding(.vertical, DesignSystem.Spacing.small)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ProfileGeneralSection: View {
    @Binding var isDarkTheme: Bool
    @Binding var useKilograms: Bool
    @Binding var defaultRestTime: Int
    @Binding var showingRestTimePicker: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("General")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    Button(action: {
                        showingRestTimePicker = true
                    }) {
                        HStack {
                            GradientIcon(
                                systemName: "timer",
                                gradient: DesignSystem.Gradients.secondary,
                                size: 24
                            )
                            
                            Text("Default Rest Time")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Spacer()
                            
                            Text("\(defaultRestTime) seconds")
                                .font(.subheadline)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            GradientIcon(
                                systemName: "chevron.right",
                                gradient: DesignSystem.Gradients.primary,
                                size: 16
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack {
                        GradientIcon(
                            systemName: "scalemass",
                            gradient: DesignSystem.Gradients.success,
                            size: 24
                        )
                        
                        Text("Units")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(useKilograms ? "kg" : "lb")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $useKilograms)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        GradientIcon(
                            systemName: "moon.fill",
                            gradient: DesignSystem.Gradients.primary,
                            size: 24
                        )
                        
                        Text("Theme")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(isDarkTheme ? "Dark" : "Light")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $isDarkTheme)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct ProfileNotificationsSection: View {
    @Binding var timerNotificationsEnabled: Bool
    @Binding var soundsEnabled: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Notifications")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    HStack {
                        GradientIcon(
                            systemName: "bell.fill",
                            gradient: DesignSystem.Gradients.error,
                            size: 24
                        )
                        
                        Text("Timer Notifications")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(timerNotificationsEnabled ? "On" : "Off")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $timerNotificationsEnabled)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        GradientIcon(
                            systemName: "speaker.wave.2.fill",
                            gradient: DesignSystem.Gradients.primary,
                            size: 24
                        )
                        
                        Text("Sounds")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(soundsEnabled ? "On" : "Off")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $soundsEnabled)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct ProfileInformationSection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Information")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    Button(action: {
                        // Help & Support action
                    }) {
                        HStack {
                            GradientIcon(
                                systemName: "questionmark.circle",
                                gradient: DesignSystem.Gradients.primary,
                                size: 24
                            )
                            
                            Text("Help & Support")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Spacer()
                            
                            GradientIcon(
                                systemName: "chevron.right",
                                gradient: DesignSystem.Gradients.primary,
                                size: 16
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Rate App action
                    }) {
                        HStack {
                            GradientIcon(
                                systemName: "star",
                                gradient: DesignSystem.Gradients.warning,
                                size: 24
                            )
                            
                            Text("Rate App")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Spacer()
                            
                            GradientIcon(
                                systemName: "chevron.right",
                                gradient: DesignSystem.Gradients.primary,
                                size: 16
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ProfileVersionSection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            HStack {
                Spacer()
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                Spacer()
            }
            .padding(.vertical, DesignSystem.Spacing.small)
        }
    }
}



struct RestTimePickerView: View {
    @Binding var selectedTime: Int
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    private let restTimeOptions = Array(0...300)
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    ModalContainer {
                        VStack(spacing: DesignSystem.Spacing.large) {
                            // Header
                            HStack {
                                GradientIcon(
                                    systemName: "timer",
                                    gradient: DesignSystem.Gradients.secondary,
                                    size: 32
                                )
                                
                                Text("Select Default Rest Time")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Spacer()
                            }
                            
                            // Picker
                            Picker("Rest Time", selection: $selectedTime) {
                                ForEach(restTimeOptions, id: \.self) { seconds in
                                    Text("\(seconds) seconds").tag(seconds)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 200)
                            
                            // Buttons
                            HStack(spacing: DesignSystem.Spacing.medium) {
                                Button("Cancel") {
                                    isPresented = false
                                }
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .padding(.horizontal, DesignSystem.Spacing.large)
                                .padding(.vertical, DesignSystem.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                                
                                GradientButton(
                                    title: "Done",
                                    gradient: DesignSystem.Gradients.secondary
                                ) {
                                    isPresented = false
                                }
                            }
                        }
                    }
                }
                .padding(DesignSystem.Spacing.large)
            }
        }
    }
}



#Preview {
    ContentView()
}
