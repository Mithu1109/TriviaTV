//
//  ScoreboardView.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

struct ScoreboardView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var gameVM: GameViewModel
    @FocusState private var focusedAction: ScoreboardAction?

    enum ScoreboardAction: Hashable {
        case playAgain
        case mainMenu
    }

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            // Confetti for match completion
            ConfettiView()

            VStack(spacing: 36) {
                // MARK: - Header
                VStack(spacing: 8) {
                    HStack(spacing: 14) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 38))
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow, radius: 10)
                        Text("FINAL SCOREBOARD")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .tracking(6)
                            .foregroundColor(.yellow)
                        Image(systemName: "crown.fill")
                            .font(.system(size: 38))
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow, radius: 10)
                    }

                    Text("Match Champions")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.top, 24)

                // MARK: - Champion Podium & Player Standings
                let standings = gameVM.sortedStandings
                if let champion = standings.first {
                    // 1st Place Golden Banner / Hero Card
                    HStack(spacing: 30) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.yellow, Color.orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: Color.yellow.opacity(0.8), radius: 24)

                            Image(systemName: "trophy.fill")
                                .font(.system(size: 52, weight: .bold))
                                .foregroundColor(.black)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 12) {
                                Text("1ST PLACE • WINNER")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(.yellow)
                                    .tracking(2)

                                Text("🏆 CHAMPION")
                                    .font(.system(size: 14, weight: .black))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow.opacity(0.2))
                                    .foregroundColor(.yellow)
                                    .clipShape(Capsule())
                            }

                            Text(champion.name)
                                .font(.system(size: 46, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)

                            HStack(spacing: 20) {
                                Label("\(champion.correctCount)/\(champion.totalAnswered) Correct", systemImage: "checkmark.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.green)

                                Label("\(champion.accuracyPercentage)% Accuracy", systemImage: "chart.bar.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.cyan)
                            }
                        }

                        Spacer()

                        // Champion Score Big Display
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(champion.score)")
                                .font(.system(size: 68, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .white],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            Text("TOTAL POINTS")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 48)
                    .padding(.vertical, 24)
                    .frame(maxWidth: 1200)
                    .background(
                        LinearGradient(
                            colors: [Color.yellow.opacity(0.2), Color.orange.opacity(0.1)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.yellow, Color.orange.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .shadow(color: Color.yellow.opacity(0.3), radius: 24, x: 0, y: 8)
                }

                // MARK: - Runner-Up Cards (Ranked List)
                if standings.count > 1 {
                    HStack(spacing: 24) {
                        ForEach(1..<standings.count, id: \.self) { rankIndex in
                            let player = standings[rankIndex]
                            let rankMedal = rankIndex == 1 ? "2nd" : (rankIndex == 2 ? "3rd" : "4th")
                            let rankColor = rankIndex == 1 ? Color(white: 0.8) : (rankIndex == 2 ? Color(red: 0.8, green: 0.5, blue: 0.2) : Color.cyan)

                            HStack(spacing: 18) {
                                ZStack {
                                    Circle()
                                        .fill(rankColor.opacity(0.25))
                                        .frame(width: 54, height: 54)
                                    Text(rankMedal)
                                        .font(.system(size: 22, weight: .black, design: .rounded))
                                        .foregroundColor(rankColor)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(player.name)
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(.white)
                                    HStack(spacing: 12) {
                                        Text("\(player.correctCount)/\(player.totalAnswered) Correct")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(.green)
                                        Text("(\(player.accuracyPercentage)%)")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(.cyan)
                                    }
                                }

                                Spacer()

                                Text("\(player.score) pts")
                                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .frame(maxWidth: 580)
                            .background(Color.white.opacity(0.06))
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                        }
                    }
                    .frame(maxWidth: 1200)
                }

                Spacer()

                // MARK: - Action Buttons (Play Again & Main Menu)
                HStack(spacing: 40) {
                    // Play Again
                    Button {
                        SoundManager.shared.playFocusClick()
                        gameVM.resetToCategories()
                        // Pop back to Category Selection
                        while navigationPath.count > 1 {
                            navigationPath.removeLast()
                        }
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.system(size: 32, weight: .bold))
                            Text("Play Again")
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 20)
                        .background(Color.cyan)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 24, activeBorderColor: .cyan))
                    .focused($focusedAction, equals: .playAgain)

                    // Main Menu
                    Button {
                        SoundManager.shared.playFocusClick()
                        gameVM.resetToCategories()
                        navigationPath = NavigationPath()
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 30, weight: .bold))
                            Text("Main Menu")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 20)
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 24, activeBorderColor: .white))
                    .focused($focusedAction, equals: .mainMenu)
                }
                .padding(.bottom, 36)
            }
            .padding(.horizontal, 60)
        }
        .onAppear {
            if focusedAction == nil {
                focusedAction = .playAgain
            }
        }
    }
}
