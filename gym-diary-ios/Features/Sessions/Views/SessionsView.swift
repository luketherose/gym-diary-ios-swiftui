//
//  SessionsView.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct SessionsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var sessionManager = SessionManager.shared
    @State private var showingWorkoutSelector = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Header
                    HStack {
                        Text("Sessions")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        if sessionManager.activeSession == nil {
                            Button(action: {
                                showingWorkoutSelector = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.top, DesignSystem.Spacing.large)
                    
                    // Active Session Panel
                    if let session = sessionManager.activeSession {
                        ActiveSessionPanel(session: session) {
                            sessionManager.completeSession(session)
                        } onCancel: {
                            sessionManager.cancelSession(session)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                    }
                    
                    // Past Sessions
                    if !sessionManager.pastSessions.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                            Text("Past Sessions")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                .padding(.horizontal, DesignSystem.Spacing.large)
                            
                            ScrollView {
                                LazyVStack(spacing: DesignSystem.Spacing.medium) {
                                    ForEach(sessionManager.pastSessions) { session in
                                        PastSessionCard(session: session)
                                    }
                                }
                                .padding(.horizontal, DesignSystem.Spacing.large)
                            }
                        }
                    } else {
                        // Empty State
                        VStack(spacing: DesignSystem.Spacing.large) {
                            Image(systemName: "timer")
                                .font(.system(size: 60))
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            Text("No Sessions Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("Start your first workout session to begin tracking your progress")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .multilineTextAlignment(.center)
                            
                            if sessionManager.activeSession == nil {
                                Button(action: {
                                    showingWorkoutSelector = true
                                }) {
                                    Text("Start Session")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, DesignSystem.Spacing.large)
                                        .padding(.vertical, DesignSystem.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .fill(DesignSystem.Colors.primary)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingWorkoutSelector) {
            WorkoutSelectorView { workout in
                sessionManager.startSession(from: workout)
                showingWorkoutSelector = false
            }
        }
        .onAppear {
            // No longer needed as workouts are managed by SessionManager
        }
    }
}

#Preview {
    SessionsView()
        .preferredColorScheme(.dark)
}
