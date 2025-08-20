import SwiftUI
import UniformTypeIdentifiers

// MARK: - Drag State
enum DragState: Equatable {
    case none
    case dragging
    case overSection(Int)
    case overWorkout(section: Int, index: Int)
}

// MARK: - Workouts View
struct WorkoutsView: View {
    @State private var sections: [WorkoutSection] = []
    @State private var showingCreateSection = false
    @State private var newSectionName = ""
    @State private var dragState: DragState = .none
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Header
                    HStack {
                        Text("Workouts")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Button(action: {
                            newSectionName = ""
                            showingCreateSection = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.top, DesignSystem.Spacing.large)
                    
                    // Sections
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.large) {
                            ForEach(sections.indices, id: \.self) { sectionIndex in
                                WorkoutSectionView(
                                    section: $sections[sectionIndex],
                                    sectionIndex: sectionIndex,
                                    onWorkoutMoved: { fromSection, fromIndex, toSection, toIndex in
                                        moveWorkout(from: fromSection, from: fromIndex, to: toSection, to: toIndex)
                                    },
                                    onWorkoutDeleted: { workoutId in
                                        deleteWorkout(workoutId: workoutId)
                                    },
                                    onSectionDeleted: { sectionId in
                                        deleteSection(sectionId: sectionId)
                                    },
                                    dragState: $dragState
                                )
                                .opacity(dragState == .dragging ? 0.6 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: dragState)
                                .onDrag {
                                    dragState = .dragging
                                    return NSItemProvider(object: "section:\(sectionIndex)" as NSString)
                                }
                                .onDrop(of: [.plainText], delegate: SectionDropDelegate(
                                    toSectionIndex: sectionIndex,
                                    onSectionMoved: { from, to in moveSection(from: from, to: to) },
                                    onWorkoutMovedToSection: { fromSection, fromIndex, toSection, toIndex in
                                        // Insert at the end of the destination section
                                        let endPosition = sections[toSection].workouts.count
                                        moveWorkout(from: fromSection, from: fromIndex, to: toSection, to: endPosition)
                                    },
                                    dragState: $dragState
                                ))
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.bottom, DesignSystem.Spacing.large)
                    }
                }
            }
        }
        .alert("Create New Section", isPresented: $showingCreateSection) {
            TextField("Section Name", text: $newSectionName)
            Button("Cancel", role: .cancel) {}
            Button("Create") {
                createSection()
            }
            .disabled(newSectionName.isEmpty)
        } message: {
            Text("Enter the name for your new section.")
        }
        .onAppear { syncWorkouts() }
    }
    
    private func syncWorkouts() {
        SessionManager.shared.workouts = sections.flatMap { $0.workouts }
    }
    
    private func createSection() {
        guard !newSectionName.isEmpty else { return }
        
        let newSection = WorkoutSection(
            userId: "user123",
            name: newSectionName,
            workouts: []
        )
        sections.append(newSection)
        newSectionName = ""
        syncWorkouts()
    }
    
    private func moveSection(from fromIndex: Int, to toIndex: Int) {
        sections.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex)
        syncWorkouts()
    }
    
    private func moveWorkout(from fromSectionIndex: Int, from fromWorkoutIndex: Int, to toSectionIndex: Int, to toWorkoutIndex: Int) {
        // Allow cross-section moves
        let workout = sections[fromSectionIndex].workouts[fromWorkoutIndex]
        sections[fromSectionIndex].workouts.remove(at: fromWorkoutIndex)
        
        // Insert at the specified position in the target section
        let insertIndex = min(toWorkoutIndex, sections[toSectionIndex].workouts.count)
        sections[toSectionIndex].workouts.insert(workout, at: insertIndex)
        syncWorkouts()
        
        // Reset drag state after move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dragState = .none
        }
    }
    
    private func deleteWorkout(workoutId: String) {
        for sectionIndex in sections.indices {
            if let workoutIndex = sections[sectionIndex].workouts.firstIndex(where: { $0.id == workoutId }) {
                sections[sectionIndex].workouts.remove(at: workoutIndex)
                syncWorkouts()
                return
            }
        }
    }
    
    private func deleteSection(sectionId: String) {
        sections.removeAll { $0.id == sectionId }
        syncWorkouts()
    }
}

// MARK: - Workout Section View
struct WorkoutSectionView: View {
    @Binding var section: WorkoutSection
    let sectionIndex: Int
    let onWorkoutMoved: (Int, Int, Int, Int) -> Void
    let onWorkoutDeleted: (String) -> Void
    let onSectionDeleted: (String) -> Void
    @Binding var dragState: DragState
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingCreateWorkout = false
    @State private var showingDeleteAlert = false
    @State private var newWorkoutName = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Top border line
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                // Section Header
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            section.isExpanded.toggle()
                        }
                    }) {
                        HStack(spacing: DesignSystem.Spacing.small) {
                            Text(section.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Image(systemName: section.isExpanded ? "chevron.down" : "chevron.right")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .animation(.easeInOut(duration: 0.2), value: section.isExpanded)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Add workout button
                    Button(action: {
                        showingCreateWorkout = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                    
                    // Delete section button
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "minus")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.vertical, DesignSystem.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(dragState == .overSection(sectionIndex) ? Color(.systemGray5) : Color.clear)
                        .animation(.easeInOut(duration: 0.2), value: dragState)
                )
                
                // Workouts Grid (hidden when collapsed)
                if section.isExpanded {
                    if section.workouts.isEmpty {
                        VStack(spacing: 0) {
                            // Drop indicator when dragging over empty section
                            if case .overWorkout(let dragSection, let dragIndex) = dragState,
                               dragSection == sectionIndex && dragIndex == 0 {
                                Rectangle()
                                    .fill(DesignSystem.Colors.primary)
                                    .frame(height: 3)
                                    .padding(.horizontal, DesignSystem.Spacing.small)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            EmptyWorkoutSectionView()
                                .contentShape(Rectangle())
                                .onDrop(of: [.plainText], delegate: WorkoutDropDelegate(
                                    toSectionIndex: sectionIndex,
                                    toWorkoutIndex: 0,
                                    section: $section,
                                    onWorkoutDropped: onWorkoutMoved,
                                    dragState: $dragState
                                ))
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.bottom, DesignSystem.Spacing.medium)
                    } else {
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            ForEach(section.workouts.indices, id: \.self) { workoutIndex in
                                VStack(spacing: 0) {
                                    // Drop indicator above workout
                                    if case .overWorkout(let dragSection, let dragIndex) = dragState,
                                       dragSection == sectionIndex && dragIndex == workoutIndex {
                                        Rectangle()
                                            .fill(DesignSystem.Colors.primary)
                                            .frame(height: 3)
                                            .padding(.horizontal, DesignSystem.Spacing.small)
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                    
                                    WorkoutCard(
                                        workout: $section.workouts[workoutIndex],
                                        onDelete: {
                                            onWorkoutDeleted(section.workouts[workoutIndex].id)
                                        },
                                        isDragging: dragState == .dragging
                                    )
                                    .frame(maxWidth: .infinity)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            onWorkoutDeleted(section.workouts[workoutIndex].id)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .onDrag {
                                        dragState = .dragging
                                        let provider = NSItemProvider()
                                        provider.registerDataRepresentation(forTypeIdentifier: UTType.plainText.identifier, visibility: .all) { completion in
                                            let string = "\(sectionIndex):\(workoutIndex)"
                                            completion(Data(string.utf8), nil)
                                            return nil
                                        }
                                        return provider
                                    }
                                    .onDrop(of: [.plainText], delegate: WorkoutDropDelegate(
                                        toSectionIndex: sectionIndex,
                                        toWorkoutIndex: workoutIndex,
                                        section: $section,
                                        onWorkoutDropped: onWorkoutMoved,
                                        dragState: $dragState
                                    ))
                                }
                            }
                            
                            // Drop indicator at the end of section
                            if case .overWorkout(let dragSection, let dragIndex) = dragState,
                               dragSection == sectionIndex && dragIndex == section.workouts.count {
                                Rectangle()
                                    .fill(DesignSystem.Colors.primary)
                                    .frame(height: 3)
                                    .padding(.horizontal, DesignSystem.Spacing.small)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            // Drop area at the end of section for last position
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 20)
                                .onDrop(of: [.plainText], delegate: WorkoutDropDelegate(
                                    toSectionIndex: sectionIndex,
                                    toWorkoutIndex: section.workouts.count,
                                    section: $section,
                                    onWorkoutDropped: onWorkoutMoved,
                                    dragState: $dragState
                                ))
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.bottom, DesignSystem.Spacing.medium)
                    }
                }
            }
            
            // Bottom border line
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: dragState)
        .animation(.easeInOut(duration: 0.2), value: section.isExpanded)
        .onDrop(of: [.plainText], delegate: SectionDropDelegate(
            toSectionIndex: sectionIndex,
            onSectionMoved: { from, to in
                // This is for section reordering, not workout reordering
                // Handled in WorkoutsView
            },
            onWorkoutMovedToSection: { fromSection, fromIndex, toSection, toIndex in
                onWorkoutMoved(fromSection, fromIndex, toSection, toIndex)
            },
            dragState: $dragState
        ))
        .alert("Create New Workout", isPresented: $showingCreateWorkout) {
            TextField("Workout Name", text: $newWorkoutName)
            Button("Cancel", role: .cancel) {}
            Button("Create") {
                createWorkout()
            }
            .disabled(newWorkoutName.isEmpty)
        } message: {
            Text("Enter the name for your new workout.")
        }
        .alert("Delete Section", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onSectionDeleted(section.id)
            }
        } message: {
            Text("Are you sure you want to delete '\(section.name)'? This will also delete all workouts in this section.")
        }
        .onChange(of: showingCreateWorkout) { _, isShowing in
            if !isShowing {
                newWorkoutName = ""
            }
        }
    }
    
    private func createWorkout() {
        guard !newWorkoutName.isEmpty else { return }
        
        let newWorkout = Workout(
            userId: "user123",
            name: newWorkoutName,
            sectionId: section.id,
            iconName: "dumbbell",
            colorName: "Blue",
            chipText: ""
        )
        section.workouts.append(newWorkout)
        newWorkoutName = ""
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
    }
}

// MARK: - Workout Drop Delegate
struct WorkoutDropDelegate: DropDelegate {
    let toSectionIndex: Int
    let toWorkoutIndex: Int
    @Binding var section: WorkoutSection
    let onWorkoutDropped: (Int, Int, Int, Int) -> Void
    @Binding var dragState: DragState
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.plainText]).first else { return false }
        itemProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, _) in
            DispatchQueue.main.async {
                guard let data = data as? Data,
                      let payload = String(data: data, encoding: .utf8) else { return }
                // Expecting format "section:index"
                let parts = payload.split(separator: ":")
                if parts.count == 2, let fromSection = Int(parts[0]), let fromIndex = Int(parts[1]) {
                    onWorkoutDropped(fromSection, fromIndex, toSectionIndex, toWorkoutIndex)
                }
                dragState = .none
            }
        }
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func dropEntered(info: DropInfo) {
        // Visual feedback when entering drop zone
        withAnimation(.easeInOut(duration: 0.2)) {
            dragState = .overWorkout(section: toSectionIndex, index: toWorkoutIndex)
        }
    }
    
    func dropExited(info: DropInfo) {
        // Visual feedback when exiting drop zone
        withAnimation(.easeInOut(duration: 0.2)) {
            if case .overWorkout(let dragSection, let dragIndex) = dragState,
               dragSection == toSectionIndex && dragIndex == toWorkoutIndex {
                dragState = .dragging
            }
        }
    }
}

// MARK: - Section Drop Delegate (reorder sections)
struct SectionDropDelegate: DropDelegate {
    let toSectionIndex: Int
    let onSectionMoved: (_ from: Int, _ to: Int) -> Void
    let onWorkoutMovedToSection: (Int, Int, Int, Int) -> Void
    @Binding var dragState: DragState
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.plainText]).first else { return false }
        itemProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, _) in
            DispatchQueue.main.async {
                guard let data = data as? Data,
                      let payload = String(data: data, encoding: .utf8) else { return }
                if payload.hasPrefix("section:") { // It's a section being dragged
                    let components = payload.split(separator: ":").map(String.init)
                    if components.count == 2, let fromIndex = Int(components[1]) {
                        onSectionMoved(fromIndex, toSectionIndex)
                    }
                } else if payload.contains(":") { // It's a workout being dragged
                    let components = payload.split(separator: ":").map(String.init)
                    if components.count == 2,
                       let fromSectionIndex = Int(components[0]),
                       let fromWorkoutIndex = Int(components[1]) {
                        // Drop workout - the callback will handle positioning
                        onWorkoutMovedToSection(fromSectionIndex, fromWorkoutIndex, toSectionIndex, 0)
                    }
                }
                dragState = .none
            }
        }
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? { DropProposal(operation: .move) }
    
    func dropEntered(info: DropInfo) {
        // Visual feedback when entering section drop zone
        withAnimation(.easeInOut(duration: 0.2)) {
            dragState = .overSection(toSectionIndex)
        }
    }
    
    func dropExited(info: DropInfo) {
        // Visual feedback when exiting section drop zone
        withAnimation(.easeInOut(duration: 0.2)) {
            if case .overSection(let dragSection) = dragState,
               dragSection == toSectionIndex {
                dragState = .dragging
            }
        }
    }
}







// MARK: - Workout Card
struct WorkoutCard: View {
    @Binding var workout: Workout
    var onDelete: (() -> Void)? = nil
    var isDragging: Bool = false
    @State private var showingWorkoutDetails = false
    @Environment(\.colorScheme) private var colorScheme
    
    private var workoutIcon: WorkoutIcon {
        WorkoutIcon.allIcons.first { $0.systemName == workout.iconName } ?? 
        WorkoutIcon(systemName: "dumbbell", displayName: "Dumbbell", category: "Strength")
    }
    
    private var workoutColor: WorkoutColor {
        WorkoutColor.allColors.first { $0.name == workout.colorName } ?? 
        WorkoutColor(color: .blue, name: "Blue", isDark: false)
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
                        text: "\(workout.exercises.count + workout.circuits.count)",
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
                    
                    if let lastExecuted = workout.lastExecuted {
                        Text("Last: \(lastExecuted, style: .date)")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    } else {
                        Text("Never executed")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
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
                            .fill(
                                LinearGradient(
                                    colors: [
                                        workoutColor.color.opacity(colorScheme == .dark ? 0.25 : 0.15),
                                        workoutColor.color.opacity(colorScheme == .dark ? 0.1 : 0.05),
                                        Color.white.opacity(colorScheme == .dark ? 0.05 : 0.03)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .shadow(
                color: DesignSystem.Shadows.adaptive(for: colorScheme).color,
                radius: DesignSystem.Shadows.adaptive(for: colorScheme).radius,
                x: DesignSystem.Shadows.adaptive(for: colorScheme).x,
                y: DesignSystem.Shadows.adaptive(for: colorScheme).y
            )
            .opacity(isDragging ? 0.6 : 1.0)
            .scaleEffect(isDragging ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isDragging)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingWorkoutDetails) {
            WorkoutDetailView(workout: $workout, onDelete: onDelete, onDismiss: {
                showingWorkoutDetails = false
            })
        }
    }
}

// MARK: - Workout Detail View
struct WorkoutDetailView: View {
    @Binding var workout: Workout
    var onDelete: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var sessionManager = SessionManager.shared
    @State private var showingAddExercise = false
    @State private var showingEditWorkout = false
    @State private var showingEditExercise = false
    @State private var editingExerciseIndex: Int? = nil
    @State private var confirmDelete = false
    
    private var workoutIcon: WorkoutIcon {
        WorkoutIcon.allIcons.first { $0.systemName == workout.iconName } ?? 
        WorkoutIcon(systemName: "dumbbell", displayName: "Dumbbell", category: "Strength")
    }
    
    private var workoutColor: WorkoutColor {
        WorkoutColor.allColors.first { $0.name == workout.colorName } ?? 
        WorkoutColor(color: .blue, name: "Blue", isDark: false)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
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
                            
                            Text("\(workout.exercises.count + workout.circuits.count) exercises")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                        
                        Spacer()
                        
                        Button("Edit") {
                            showingEditWorkout = true
                        }
                        .foregroundColor(DesignSystem.Colors.primary)
                        
                        Button(action: { confirmDelete = true }) {
                            Image(systemName: "trash")
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 8)
                        .alert("sicuro di voler cancellare il workout?", isPresented: $confirmDelete) {
                            Button("Cancel", role: .cancel) {}
                            Button("Delete", role: .destructive) {
                                onDelete?()
                            }
                        }


                    }
                    .padding(DesignSystem.Spacing.large)
                    
                    // Scrollable content with persistent header/footer
                    ZStack {
                        ScrollView {
                            VStack(spacing: 0) {
                                ExercisesListView(workout: $workout)
                                    .frame(maxWidth: .infinity, alignment: .top)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Top gradient indicator
                        VStack {
                            LinearGradient(
                                colors: [
                                    DesignSystem.Colors.background(for: colorScheme),
                                    DesignSystem.Colors.background(for: colorScheme).opacity(0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 20)
                            Spacer()
                        }
                        
                        // Bottom gradient indicator
                        VStack {
                            Spacer()
                            LinearGradient(
                                colors: [
                                    DesignSystem.Colors.background(for: colorScheme).opacity(0),
                                    DesignSystem.Colors.background(for: colorScheme)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 20)
                        }
                    }
                    
                    // Start Workout Button
                    GradientButton(
                        title: "Start Workout",
                        gradient: LinearGradient(colors: [workoutColor.color, workoutColor.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    ) {
                        startWorkoutSession()
                    }
                    .disabled(workout.exercises.isEmpty && workout.circuits.isEmpty)
                    .opacity((workout.exercises.isEmpty && workout.circuits.isEmpty) ? 0.5 : 1.0)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.bottom, DesignSystem.Spacing.large)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        // Dismiss the full screen cover
                        onDismiss?()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
            .toolbar(.hidden, for: .tabBar)
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView(
                onAdd: { newExercise in
                    workout.exercises.append(newExercise)
                },
                onAddCircuit: { circuit, exercises in
                    // Add circuit and its exercises
                    workout.circuits.append(circuit)
                    workout.exercises.append(contentsOf: exercises)
                }
            )
            .presentationDetents([.large])
        }
        .sheet(isPresented: $showingEditWorkout) {
            EditWorkoutView(workout: $workout)
                .presentationDetents([.large])
        }
        .onChange(of: sessionManager.shouldNavigateToSessions) { _, shouldNavigate in
            if shouldNavigate {
                // Close the modal when session is started
                onDismiss?()
            }
        }
    }
    
    private func startWorkoutSession() {
        SessionManager.shared.startSession(from: workout)
    }
}
// SetEditorRow moved to Features/Workouts/Views/SetEditorRow.swift

// MARK: - Add Exercise Sheet
extension WorkoutDetailView {
    // move state inside main struct - allowed as computed via backing storage
}

// MARK: - Edit Workout View
struct EditWorkoutView: View {
    @Binding var workout: Workout
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var tempName: String = ""
    @State private var tempChip: String = ""

    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            Text("Workout Name")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            TextField("Enter workout name", text: $tempName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                        }
                        

                        
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            Text("Chip Text")
                                .font(.headline)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            TextField("e.g., Push, Pull, Legs...", text: $tempChip)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                        }
                    }
                    .padding(DesignSystem.Spacing.large)
                }
            }
            .navigationTitle("Edit Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) { Button("Save") { save() }.disabled(tempName.isEmpty) }
            }
        }
        .onAppear { load() }
    }
    
    private func load() {
        tempName = workout.name
        tempChip = workout.chipText
    }
    
    private func save() {
        workout.name = tempName
        workout.chipText = tempChip
        workout.iconName = "dumbbell"
        workout.colorName = "Blue"
        dismiss()
    }
}

// MARK: - Exercise Detail Row
struct ExerciseDetailRow: View {
    let exercise: Exercise
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
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
                        
                        Text("rest \(set.restTime)s")
                            .font(.caption2)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
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

