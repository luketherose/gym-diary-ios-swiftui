import SwiftUI

struct SetEditorRow: View {
    @Binding var set: ExerciseSet
    @Environment(\.colorScheme) private var colorScheme
    // RPE temporarily disabled
    private enum PickerType { case reps, weight, rest }
    @State private var showingPicker: Bool = false
    @State private var pickerType: PickerType = .rest
    @State private var tempReps: Int = 10
    @State private var tempWeight: Double = 0
    @State private var tempRest: Int = 60
    
    var body: some View {
        HStack(spacing: 12) {
            // Inline text: reps x weight kg (RPE N)
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
                // RPE UI hidden for now
            }
            Spacer()
            // Rest on same row (tap to open seconds picker)
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
        // RPE toggle removed
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


