//
//  HowToPlayView.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

struct HowToPlayView: View {
    @Binding var navigationPath: NavigationPath
    @FocusState private var focusedButton: Bool?

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            VStack(spacing: 36) {
                // Header
                HStack {
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

                    Spacer()

                    VStack(spacing: 4) {
                        Text("GUIDE & INSTRUCTIONS")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .tracking(4)
                            .foregroundColor(.cyan)

                        Text("How to Play on Apple TV")
                            .font(.system(size: 44, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Balance layout
                    Color.clear
                        .frame(width: 140, height: 1)
                }
                .padding(.horizontal, 60)
                .padding(.top, 24)

                // 4 Interactive Step Cards
                HStack(spacing: 28) {
                    GuideStepCard(
                        stepNumber: "1",
                        icon: "hand.draw.fill",
                        iconColor: .cyan,
                        title: "Siri Remote",
                        description: "Swipe on the touch surface or press the directional ring to fluidly glide focus between answer cards."
                    )

                    GuideStepCard(
                        stepNumber: "2",
                        icon: "hand.tap.fill",
                        iconColor: .purple,
                        title: "Lock In Choice",
                        description: "Click the center button to lock in your answer choice before the countdown runs out."
                    )

                    GuideStepCard(
                        stepNumber: "3",
                        icon: "timer",
                        iconColor: .orange,
                        title: "Beat the Clock",
                        description: "Each question has a 15s timer. Every correct answer scores +100 points, plus up to +50 speed bonus!"
                    )

                    GuideStepCard(
                        stepNumber: "4",
                        icon: "person.3.sequence.fill",
                        iconColor: .green,
                        title: "Family Turns",
                        description: "Support for 1-4 players with pass-and-play turns. The glowing HUD tells you whose turn it is to take the remote!"
                    )
                }
                .padding(.horizontal, 60)

                Spacer()

                // Bottom Call-to-Action Button
                Button {
                    SoundManager.shared.playFocusClick()
                    navigationPath.removeLast()
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                        Text("Ready to Play")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                    }
                    .foregroundColor(.black)
                    .frame(width: 380, height: 76)
                    .background(Color.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                }
                .buttonStyle(TvOSCardButtonStyle(cornerRadius: 22, activeBorderColor: .cyan))
                .focused($focusedButton, equals: true)
                .padding(.bottom, 36)
            }
        }
        .onAppear {
            focusedButton = true
        }
    }
}

// MARK: - Guide Step Card
private struct GuideStepCard: View {
    let stepNumber: String
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.25))
                        .frame(width: 64, height: 64)
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(iconColor)
                }

                Spacer()

                Text("STEP \(stepNumber)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.45))
            }

            Text(title)
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundColor(.white)

            Text(description)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color.white.opacity(0.75))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(26)
        .frame(maxWidth: .infinity, maxHeight: 380)
        .background(Color.white.opacity(0.06))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}
