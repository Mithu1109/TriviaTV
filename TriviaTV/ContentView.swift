//
//  ContentView.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameVM = GameViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            HomeView(navigationPath: $navigationPath, gameVM: gameVM)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .categorySelection:
                        CategorySelectionView(navigationPath: $navigationPath, gameVM: gameVM)
                    case .activeGame:
                        ActiveGameView(navigationPath: $navigationPath, gameVM: gameVM)
                    case .scoreboard:
                        ScoreboardView(navigationPath: $navigationPath, gameVM: gameVM)
                    case .leaderboard:
                        LeaderboardView(navigationPath: $navigationPath)
                    case .howToPlay:
                        HowToPlayView(navigationPath: $navigationPath)
                    }
                }
        }
        .environmentObject(gameVM)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
