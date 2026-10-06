//
//  CategorySelectionView.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

struct CategorySelectionView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var gameVM: GameViewModel
    @FocusState private var focusedCategory: TriviaCategory?
    @FocusState private var focusedControl: String?

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            VStack(spacing: 30) {
                // MARK: - Header
                HStack(alignment: .center) {
                    Button {
                        navigationPath.removeLast()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24, weight: .bold))
                            Text("Back")
                                .font(.system(size: 26, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 18))
                    .focused($focusedControl, equals: "back")

                    Spacer()

                    VStack(spacing: 4) {
                        Text("SELECT CATEGORY & PLAYERS")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .tracking(4)
                            .foregroundColor(.cyan)

                        Text("Choose your trivia battleground")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Quick start match button
                    Button {
                        SoundManager.shared.playFocusClick()
                        gameVM.startMatch()
                        navigationPath.append(AppRoute.activeGame)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 26, weight: .bold))
                            Text("Start Game")
                                .font(.system(size: 26, weight: .heavy))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 20, activeBorderColor: .yellow))
                    .focused($focusedControl, equals: "startNow")
                }
                .padding(.horizontal, 60)
                .padding(.top, 20)

                // MARK: - Match Configuration Bar (Player Count & Rounds)
                HStack(spacing: 40) {
                    // Player Count Selector
                    HStack(spacing: 16) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.cyan)
                        Text("Players:")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        ForEach(1...4, id: \.self) { count in
                            Button {
                                SoundManager.shared.playFocusClick()
                                gameVM.setPlayerCount(count)
                            } label: {
                                Text("\(count)P")
                                    .font(.system(size: 22, weight: .heavy))
                                    .foregroundColor(gameVM.players.count == count ? .black : .white)
                                    .frame(width: 64, height: 50)
                                    .background(
                                        gameVM.players.count == count ? Color.cyan : Color.white.opacity(0.12)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(TvOSCardButtonStyle(cornerRadius: 14, activeBorderColor: .cyan))
                            .focused($focusedControl, equals: "player_\(count)")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.25))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    // Questions Count Selector
                    HStack(spacing: 16) {
                        Image(systemName: "number.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.orange)
                        Text("Rounds:")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        ForEach([5, 8, 10], id: \.self) { count in
                            Button {
                                SoundManager.shared.playFocusClick()
                                gameVM.totalQuestionsCount = count
                            } label: {
                                Text("\(count)")
                                    .font(.system(size: 22, weight: .heavy))
                                    .foregroundColor(gameVM.totalQuestionsCount == count ? .black : .white)
                                    .frame(width: 64, height: 50)
                                    .background(
                                        gameVM.totalQuestionsCount == count ? Color.orange : Color.white.opacity(0.12)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(TvOSCardButtonStyle(cornerRadius: 14, activeBorderColor: .orange))
                            .focused($focusedControl, equals: "rounds_\(count)")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.25))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                // MARK: - Category Grid (2 Rows x 2-3 Columns)
                let categoriesToDisplay = [
                    TriviaCategory.techGaming,
                    TriviaCategory.science,
                    TriviaCategory.history,
                    TriviaCategory.popCulture,
                    TriviaCategory.all
                ]

                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 30),
                    GridItem(.flexible(), spacing: 30),
                    GridItem(.flexible(), spacing: 30)
                ], spacing: 30) {
                    ForEach(categoriesToDisplay) { category in
                        CategoryCardView(
                            category: category,
                            isSelected: gameVM.selectedCategory == category
                        ) {
                            SoundManager.shared.playFocusClick()
                            gameVM.selectedCategory = category
                            gameVM.startMatch()
                            navigationPath.append(AppRoute.activeGame)
                        }
                        .focused($focusedCategory, equals: category)
                    }
                }
                .padding(.horizontal, 60)

                Spacer()

                // Living room hint
                HStack(spacing: 12) {
                    Image(systemName: "hand.tap.fill")
                    Text("Select any category card to lock in your topic and begin the challenge immediately")
                }
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white.opacity(0.55))
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            if focusedCategory == nil {
                focusedCategory = .techGaming
            }
        }
    }
}

// MARK: - Category Card View
struct CategoryCardView: View {
    let category: TriviaCategory
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.isFocused) private var isFocused

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: category.gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 68, height: 68)

                        Image(systemName: category.iconName)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    if isSelected {
                        Text("ACTIVE")
                            .font(.system(size: 14, weight: .black))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(category.rawValue)
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Text(category.subtitle)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.72))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                HStack {
                    Text("Click to Play")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isFocused ? .cyan : Color.white.opacity(0.6))

                    Spacer()

                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(isFocused ? .cyan : Color.white.opacity(0.4))
                }
            }
            .padding(26)
            .frame(height: 230)
            .background(
                LinearGradient(
                    colors: [
                        category.gradientColors[0].opacity(isFocused ? 0.35 : 0.15),
                        category.gradientColors[1].opacity(isFocused ? 0.25 : 0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        isFocused ? Color.white :
                        isSelected ? Color.yellow : Color.white.opacity(0.15),
                        lineWidth: isFocused ? 4 : (isSelected ? 2.5 : 1)
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? category.gradientColors[0].opacity(0.6) : Color.black.opacity(0.3),
                radius: isFocused ? 28 : 10,
                x: 0,
                y: isFocused ? 12 : 5
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.72), value: isFocused)
        }
        .buttonStyle(.plain)
    }
}
