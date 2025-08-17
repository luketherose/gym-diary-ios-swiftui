import SwiftUI

struct SetEditorRow: View {
    @Binding var set: ExerciseSet
    @Environment(\.colorScheme) private var colorScheme
    // RPE temporarily disabled
    @State private var showingRestPicker: Bool = false
    @State private var tempRest: Int = 60
    
    var body: some View {
        HStack(spacing: 12) {
            // Inline text: reps x weight kg (RPE N)
            HStack(spacing: 6) {
                TextField("0", value: $set.reps, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 32)
                Text("reps")
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                Text("x")
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                TextField("0", value: $set.weight, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 44)
                Text("kg")
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                // RPE UI hidden for now
            }
            Spacer()
            // Rest on same row (tap to open seconds picker)
            Button {
                tempRest = set.restTime
                showingRestPicker = true
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
        .sheet(isPresented: $showingRestPicker) {
            NavigationView {
                VStack {
                    Picker("Rest", selection: $tempRest) {
                        ForEach(Array(stride(from: 0, through: 600, by: 5)), id: \.self) { v in
                            Text("\(v) s").tag(v)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(WheelPickerStyle())
                }
                .navigationTitle("Rest Time")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { showingRestPicker = false }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            set.restTime = tempRest
                            showingRestPicker = false
                        }
                    }
                }
            }
        }
    }
}


