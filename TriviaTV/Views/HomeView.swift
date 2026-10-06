//
//  HomeView.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var gameVM: GameViewModel
    @FocusState private var focusedButton: HomeButton?

    enum HomeButton: Hashable {
        case startGame
        case howToPlay
        case leaderboard
    }

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            VStack(spacing: 50) {
                Spacer()

                // MARK: - App Branding & Title
                VStack(spacing: 16) {
                    HStack(spacing: 18) {
                        Image(systemName: "tv.fill")
                            .font(.system(size: 64, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.cyan, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.cyan.opacity(0.6), radius: 20, x: 0, y: 0)

                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 58, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.pink, Color.purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.pink.opacity(0.6), radius: 20, x: 0, y: 0)
                    }

                    // Main Title
                    Text("TriviaTV")
                        .font(.system(size: 88, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(white: 0.88)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 8)

                    // Subtitle / Living Room Badge
                    HStack(spacing: 12) {
                        Capsule()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 40, height: 2)

                        Text("FAMILY CHALLENGE")
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .tracking(8)
                            .foregroundColor(Color.cyan)

                        Capsule()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 40, height: 2)
                    }

                    Text("The big-screen multiplayer trivia showdown for your living room")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.75))
                        .padding(.top, 4)
                }

                Spacer()

                // MARK: - Focusable Buttons
                VStack(spacing: 24) {
                    // Start Game Button
                    Button {
                        SoundManager.shared.playFocusClick()
                        navigationPath.append(AppRoute.categorySelection)
                    } label: {
                        HStack(spacing: 20) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 32, weight: .bold))
                            Text("Start Game")
                                .font(.system(size: 36, weight: .heavy, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(width: 480, height: 86)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.25, green: 0.45, blue: 0.95), Color(red: 0.6, green: 0.2, blue: 0.95)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 24, activeBorderColor: .cyan))
                    .focused($focusedButton, equals: .startGame)

                    // How to Play Button
                    Button {
                        SoundManager.shared.playFocusClick()
                        navigationPath.append(AppRoute.howToPlay)
                    } label: {
                        HStack(spacing: 18) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 30, weight: .bold))
                            Text("How to Play")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(width: 480, height: 80)
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 22, activeBorderColor: .white))
                    .focused($focusedButton, equals: .howToPlay)

                    // Leaderboard Button
                    Button {
                        SoundManager.shared.playFocusClick()
                        navigationPath.append(AppRoute.leaderboard)
                    } label: {
                        HStack(spacing: 18) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.yellow)
                            Text("Leaderboard")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(width: 480, height: 80)
                    }
                    .buttonStyle(TvOSCardButtonStyle(cornerRadius: 22, activeBorderColor: .yellow))
                    .focused($focusedButton, equals: .leaderboard)
                }

                Spacer()

                // Remote instructions footer
                HStack(spacing: 14) {
                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                        .font(.system(size: 20))
                    Text("Use Siri Remote touch surface to navigate • Press Clickpad center to select")
                        .font(.system(size: 20, weight: .medium))
                }
                .foregroundColor(Color.white.opacity(0.55))
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 80)
            .padding(.vertical, 40)
        }
        .onAppear {
            if focusedButton == nil {
                focusedButton = .startGame
            }
        }
    }
}
