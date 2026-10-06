//
//  LeaderboardView.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

struct LeaderboardView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var storage = LeaderboardStorage.shared
    @FocusState private var focusedItem: String?

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            VStack(spacing: 32) {
                // MARK: - Header
                HStack {
                    Button {
                        navigationPath.removeLast()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .bold))
                            Text("Main Menu")
                                .font(.system(size: 26, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 18))
                    .focused($focusedItem, equals: "back")

                    Spacer()

                    VStack(spacing: 4) {
                        HStack(spacing: 12) {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                            Text("HALL OF FAME")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .tracking(4)
                                .foregroundColor(.yellow)
                        }

                        Text("Living Room All-Time Records")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Clear high scores button
                    Button {
                        storage.clearLeaderboard()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "trash")
                            Text("Reset")
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.7))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 16))
                    .focused($focusedItem, equals: "reset")
                }
                .padding(.horizontal, 60)
                .padding(.top, 24)

                // MARK: - High Scores List
                if storage.entries.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 64))
                            .foregroundColor(.cyan)
                        Text("No match records yet!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("Play a round to record the first family high score.")
                            .font(.system(size: 22))
                            .foregroundColor(Color.white.opacity(0.7))
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach(Array(storage.entries.enumerated()), id: \.element.id) { index, entry in
                                HStack(spacing: 24) {
                                    // Rank Number & Trophy
                                    ZStack {
                                        Circle()
                                            .fill(
                                                index == 0 ? Color.yellow.opacity(0.3) :
                                                index == 1 ? Color.gray.opacity(0.3) :
                                                index == 2 ? Color.orange.opacity(0.3) :
                                                Color.white.opacity(0.1)
                                            )
                                            .frame(width: 58, height: 58)

                                        if index == 0 {
                                            Image(systemName: "trophy.fill")
                                                .font(.system(size: 28))
                                                .foregroundColor(.yellow)
                                        } else {
                                            Text("#\(index + 1)")
                                                .font(.system(size: 24, weight: .black, design: .rounded))
                                                .foregroundColor(.white)
                                        }
                                    }

                                    // Player Name & Category
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(entry.playerName)
                                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                                            .foregroundColor(.white)

                                        Text(entry.categoryName)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color.white.opacity(0.65))
                                    }

                                    Spacer()

                                    // Accuracy Badge
                                    HStack(spacing: 6) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text("\(entry.accuracyPercentage)%")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(Capsule())

                                    // Date
                                    Text(entry.formattedDate)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .frame(width: 140, alignment: .trailing)

                                    // Score Points
                                    Text("\(entry.score) PTS")
                                        .font(.system(size: 32, weight: .black, design: .rounded))
                                        .foregroundColor(index == 0 ? .yellow : .white)
                                        .frame(width: 180, alignment: .trailing)
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(Color.white.opacity(0.06))
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(
                                            index == 0 ? Color.yellow.opacity(0.5) : Color.white.opacity(0.1),
                                            lineWidth: index == 0 ? 2 : 1
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            if focusedItem == nil {
                focusedItem = "back"
            }
        }
    }
}
