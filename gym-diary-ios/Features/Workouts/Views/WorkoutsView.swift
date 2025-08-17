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
    @State private var sections: [WorkoutSection] = [
        WorkoutSection(userId: "user123", name: "Strength", workouts: [
            Workout(id: "workout1", userId: "user123", name: "Push Day", exercises: [], circuits: [], iconName: "dumbbell", colorName: "blue", chipText: "Push"),
            Workout(id: "workout2", userId: "user123", name: "Pull Day", exercises: [], circuits: [], iconName: "dumbbell", colorName: "green", chipText: "Pull"),
            Workout(id: "workout3", userId: "user123", name: "Circuit Training", exercises: [
                Exercise(id: "ex1", workoutId: "workout3", name: "Push-ups", category: .bodyweight, variants: [.wideGrip], isCircuit: true, circuitId: "circuit1"),
                Exercise(id: "ex2", workoutId: "workout3", name: "Pull-ups", category: .bodyweight, variants: [.wideGrip], isCircuit: true, circuitId: "circuit1"),
                Exercise(id: "ex3", workoutId: "workout3", name: "Dips", category: .bodyweight, variants: [], isCircuit: true, circuitId: "circuit1")
            ], circuits: [
                Circuit(id: "circuit1", workoutId: "workout3", exerciseIds: ["ex1", "ex2", "ex3"], order: 0)
            ], iconName: "figure.strengthtraining.traditional", colorName: "orange", chipText: "Circuit")
        ]),
        WorkoutSection(userId: "user123", name: "Cardio", workouts: [
            Workout(id: "workout4", userId: "user123", name: "Running", exercises: [], circuits: [], iconName: "figure.running", colorName: "red", chipText: "Cardio")
        ])
    ]
    @State private var showingCreateSection = false
    @State private var newSectionName = ""
    @State private var dragState: DragState = .none
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: .dark)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Header
                    HStack {
                        Text("Workouts")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: .dark))
                        
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
                                    dragState: $dragState
                                )
                                .onDrag {
                                    dragState = .dragging
                                    return NSItemProvider(object: "section:\(sectionIndex)" as NSString)
                                }
                                .onDrop(of: [.plainText], delegate: SectionDropDelegate(
                                    toSectionIndex: sectionIndex,
                                    onSectionMoved: { from, to in moveSection(from: from, to: to) },
                                    onWorkoutMovedToSection: { fromSection, fromIndex, toSection, toIndex in
                                        moveWorkout(from: fromSection, from: fromIndex, to: toSection, to: toIndex)
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
    }
    
    private func moveSection(from fromIndex: Int, to toIndex: Int) {
        sections.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex)
    }
    
    private func moveWorkout(from fromSectionIndex: Int, from fromWorkoutIndex: Int, to toSectionIndex: Int, to toWorkoutIndex: Int) {
        // Allow cross-section moves
        let workout = sections[fromSectionIndex].workouts[fromWorkoutIndex]
        sections[fromSectionIndex].workouts.remove(at: fromWorkoutIndex)
        
        // Insert at the specified position in the target section
        let insertIndex = min(toWorkoutIndex, sections[toSectionIndex].workouts.count)
        sections[toSectionIndex].workouts.insert(workout, at: insertIndex)
    }
    
    private func deleteWorkout(workoutId: String) {
        for sectionIndex in sections.indices {
            if let workoutIndex = sections[sectionIndex].workouts.firstIndex(where: { $0.id == workoutId }) {
                sections[sectionIndex].workouts.remove(at: workoutIndex)
                return
            }
        }
    }
}

// MARK: - Workout Section View
struct WorkoutSectionView: View {
    @Binding var section: WorkoutSection
    let sectionIndex: Int
    let onWorkoutMoved: (Int, Int, Int, Int) -> Void
    let onWorkoutDeleted: (String) -> Void
    @Binding var dragState: DragState
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingCreateWorkout = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            // Section Header
            HStack {
                Text(section.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Spacer()
                
                Button(action: {
                    showingCreateWorkout = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(DesignSystem.Colors.primary)
                        .font(.title2)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.medium)
            .padding(.vertical, DesignSystem.Spacing.small)
            
            // Workouts Grid
            if section.workouts.isEmpty {
                EmptyWorkoutSectionView()
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
                                }
                            )
                            .frame(maxWidth: .infinity)
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
            }
        }
        .padding(DesignSystem.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                        .stroke(dragState == .overSection(sectionIndex) ? DesignSystem.Colors.primary : Color.clear, lineWidth: 2)
                )
        )
        .scaleEffect(dragState == .overSection(sectionIndex) ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: dragState)
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
        .sheet(isPresented: $showingCreateWorkout) {
            CreateWorkoutForSectionView(section: $section)
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
                        // Drop workout at the end of this section
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

// MARK: - Workout Icon and Color Selector
struct WorkoutIconColorSelector: View {
    @Binding var selectedIcon: WorkoutIcon
    @Binding var selectedColor: WorkoutColor
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedCategory: String
    
    private let categories = ["Strength", "Cardio", "Mobility"]
    
    init(selectedIcon: Binding<WorkoutIcon>, selectedColor: Binding<WorkoutColor>) {
        self._selectedIcon = selectedIcon
        self._selectedColor = selectedColor
        // Initialize category based on the selected icon
        self._selectedCategory = State(initialValue: selectedIcon.wrappedValue.category)
    }
    
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
                    // Only change icon if current icon is not in the new category
                    let iconsInNewCategory = WorkoutIcon.icons(for: newValue)
                    if !iconsInNewCategory.contains(where: { $0.systemName == selectedIcon.systemName }) {
                        // If current icon is not in new category, select first available
                        if let firstIcon = iconsInNewCategory.first {
                            selectedIcon = firstIcon
                        }
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
    @State private var selectedIcon = WorkoutIcon(systemName: "dumbbell", displayName: "Dumbbell", category: "Strength")
    @State private var selectedColor = WorkoutColor(color: .blue, name: "Blue", isDark: false)
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
                                
                                VStack(alignment: .center, spacing: DesignSystem.Spacing.small) {
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

// MARK: - Create Workout For Specific Section
struct CreateWorkoutForSectionView: View {
    @Binding var section: WorkoutSection
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var workoutName = ""
    @State private var selectedIcon = WorkoutIcon(systemName: "dumbbell", displayName: "Dumbbell", category: "Strength")
    @State private var selectedColor = WorkoutColor(color: .blue, name: "Blue", isDark: false)
    @State private var chipText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Header
                    HStack {
                        Button("Cancel") { dismiss() }
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        Spacer()
                        Text("Create Workout in \(section.name)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        Spacer()
                        Button("Create") { create() }
                            .foregroundColor(DesignSystem.Colors.primary)
                            .disabled(workoutName.isEmpty)
                    }
                    .padding(DesignSystem.Spacing.large)
                    
                    ScrollView {
                        VStack(spacing: DesignSystem.Spacing.large) {
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
                            
                            WorkoutIconColorSelector(
                                selectedIcon: $selectedIcon,
                                selectedColor: $selectedColor
                            )
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("Chip Text")
                                    .font(.headline)
                                TextField("e.g., Push, Pull, Legs...", text: $chipText)
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
            }
        }
    }
    
    private func create() {
        let newWorkout = Workout(
            userId: "user123",
            name: workoutName,
            sectionId: section.id,
            iconName: selectedIcon.systemName,
            colorName: selectedColor.name,
            chipText: chipText.isEmpty ? "New" : chipText
        )
        section.workouts.append(newWorkout)
        dismiss()
    }
}

// MARK: - Workout Card
struct WorkoutCard: View {
    @Binding var workout: Workout
    var onDelete: (() -> Void)? = nil
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
                    
                    // Custom chip text badge
                    GradientBadge(
                        text: workout.chipText.isEmpty ? "\(workout.exercises.count + workout.circuits.count)" : workout.chipText,
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
            WorkoutDetailView(workout: $workout, onDelete: onDelete)
        }
    }
}

// MARK: - Workout Detail View
struct WorkoutDetailView: View {
    @Binding var workout: Workout
    var onDelete: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingAddExercise = false
    @State private var showingEditWorkout = false
    @State private var showingEditExercise = false
    @State private var editingExerciseIndex: Int? = nil
    @State private var confirmDelete = false
    @State private var shouldNavigateToSessions = false
    
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
                                dismiss()
                            }
                        }

                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    }
                    .padding(DesignSystem.Spacing.large)
                    
                    ExercisesListView(workout: $workout)
                    
                    // Start Workout Button
                    GradientButton(
                        title: "Start Workout",
                        gradient: LinearGradient(colors: [workoutColor.color, workoutColor.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    ) {
                        startWorkoutSession()
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.bottom, DesignSystem.Spacing.large)
                }
            }
        }
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView { newExercise in
                workout.exercises.append(newExercise)
            }
        }
        .sheet(isPresented: $showingEditWorkout) {
            EditWorkoutView(workout: $workout)
        }
        // Placeholder for future edit sheet if needed
    }
    
    private func startWorkoutSession() {
        SessionManager.shared.startSession(from: workout)
        dismiss()
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
    @State private var selectedIcon: WorkoutIcon = WorkoutIcon(systemName: "dumbbell", displayName: "Dumbbell", category: "Strength")
    @State private var selectedColor: WorkoutColor = WorkoutColor(color: .blue, name: "Blue", isDark: false)
    
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
                        
                        WorkoutIconColorSelector(selectedIcon: $selectedIcon, selectedColor: $selectedColor)
                        
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
        selectedIcon = WorkoutIcon.allIcons.first { $0.systemName == workout.iconName } ?? 
            WorkoutIcon(systemName: "dumbbell", displayName: "Dumbbell", category: "Strength")
        selectedColor = WorkoutColor.allColors.first { $0.name == workout.colorName } ?? 
            WorkoutColor(color: .blue, name: "Blue", isDark: false)
    }
    
    private func save() {
        workout.name = tempName
        workout.chipText = tempChip
        workout.iconName = selectedIcon.systemName
        workout.colorName = selectedColor.name
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

