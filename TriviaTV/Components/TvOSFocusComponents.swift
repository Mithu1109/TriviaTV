//
//  TvOSFocusComponents.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

// MARK: - Animated Ambient Living Room Background
struct AnimatedGradientBackground: View {
    @State private var startPoint = UnitPoint.topLeading
    @State private var endPoint = UnitPoint.bottomTrailing
    @State private var pulseOrb = false

    var body: some View {
        ZStack {
            // Base Deep Midnight Gradient
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.06, blue: 0.16),
                    Color(red: 0.10, green: 0.05, blue: 0.22),
                    Color(red: 0.03, green: 0.08, blue: 0.18)
                ],
                startPoint: startPoint,
                endPoint: endPoint
            )
            .ignoresSafeArea()

            // Ambient Glow Orb 1 (Top Left)
            RadialGradient(
                colors: [
                    Color(red: 0.35, green: 0.2, blue: 0.85).opacity(0.35),
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 50,
                endRadius: pulseOrb ? 650 : 500
            )
            .ignoresSafeArea()

            // Ambient Glow Orb 2 (Bottom Right)
            RadialGradient(
                colors: [
                    Color(red: 0.9, green: 0.2, blue: 0.55).opacity(0.30),
                    Color.clear
                ],
                center: .bottomTrailing,
                startRadius: 50,
                endRadius: pulseOrb ? 750 : 550
            )
            .ignoresSafeArea()

            // Ambient Glow Orb 3 (Center Top)
            RadialGradient(
                colors: [
                    Color(red: 0.1, green: 0.7, blue: 0.9).opacity(0.20),
                    Color.clear
                ],
                center: UnitPoint(x: 0.5, y: 0.1),
                startRadius: 30,
                endRadius: 400
            )
            .ignoresSafeArea()

            // Subtle Vignette for 10-foot TV contrast
            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [Color.clear, Color.black.opacity(0.45)],
                        center: .center,
                        startRadius: 400,
                        endRadius: 1000
                    )
                )
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                startPoint = UnitPoint.topTrailing
                endPoint = UnitPoint.bottomLeading
                pulseOrb = true
            }
        }
    }
}

// MARK: - tvOS Focus-Aware Card Button Style
struct TvOSCardButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 24
    var baseBackgroundColor: Color = Color.white.opacity(0.08)
    var activeBorderColor: Color = Color.white

    func makeBody(configuration: Configuration) -> some View {
        TvOSCardButtonBody(
            configuration: configuration,
            cornerRadius: cornerRadius,
            baseBackgroundColor: baseBackgroundColor,
            activeBorderColor: activeBorderColor
        )
    }

    private struct TvOSCardButtonBody: View {
        let configuration: Configuration
        let cornerRadius: CGFloat
        let baseBackgroundColor: Color
        let activeBorderColor: Color

        @Environment(\.isFocused) private var isFocused

        var body: some View {
            configuration.label
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isFocused ? baseBackgroundColor.opacity(0.25) : baseBackgroundColor)
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(.ultraThinMaterial)
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            isFocused ? activeBorderColor : Color.white.opacity(0.15),
                            lineWidth: isFocused ? 4 : 1.5
                        )
                )
                .scaleEffect(isFocused ? 1.05 : 1.0)
                .shadow(
                    color: isFocused ? activeBorderColor.opacity(0.6) : Color.black.opacity(0.3),
                    radius: isFocused ? 28 : 10,
                    x: 0,
                    y: isFocused ? 12 : 6
                )
                .animation(.spring(response: 0.32, dampingFraction: 0.72), value: isFocused)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        }
    }
}

// MARK: - Circular Countdown Timer View
struct CircularTimerView: View {
    let timeRemaining: Int
    let totalTime: Int

    private var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(timeRemaining) / Double(totalTime)
    }

    private var timerColor: Color {
        if timeRemaining > 7 {
            return Color(red: 0.2, green: 0.85, blue: 0.95) // Vibrant cyan
        } else if timeRemaining > 3 {
            return Color(red: 1.0, green: 0.65, blue: 0.15) // Warning amber
        } else {
            return Color(red: 1.0, green: 0.25, blue: 0.35) // Urgent pulsating red
        }
    }

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(Color.white.opacity(0.12), lineWidth: 10)

            // Animated progress ring
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(
                    timerColor,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1.0), value: progress)
                .shadow(color: timerColor.opacity(0.6), radius: 8, x: 0, y: 0)

            // Numerical seconds display
            VStack(spacing: 2) {
                Text("\(timeRemaining)")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("SEC")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.6))
            }
        }
        .frame(width: 88, height: 88)
    }
}

// MARK: - 2x2 Answer Option Card View
struct AnswerOptionCardView: View {
    let letterIndex: String
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isRevealed: Bool
    let isWrongSelection: Bool
    let action: () -> Void

    @Environment(\.isFocused) private var isFocused

    private var cardBackground: some View {
        ZStack {
            // Base background
            RoundedRectangle(cornerRadius: 24)
                .fill(isFocused ? Color.white.opacity(0.22) : Color.white.opacity(0.08))

            // Correct state: Vibrant Green Gradient Layer
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.green.opacity(0.85), Color.mint.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(isRevealed && isCorrect ? 1.0 : 0.0)

            // Wrong selection state: Bold Red Gradient Layer
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.red.opacity(0.85), Color(red: 0.85, green: 0.15, blue: 0.25).opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(isRevealed && isWrongSelection ? 1.0 : 0.0)
        }
    }

    private var borderColor: Color {
        if isRevealed {
            if isCorrect {
                return Color.green
            } else if isWrongSelection {
                return Color.red
            } else {
                return Color.white.opacity(0.08)
            }
        } else {
            return isFocused ? Color.white : Color.white.opacity(0.18)
        }
    }

    private var borderWidth: CGFloat {
        if isRevealed {
            return (isCorrect || isWrongSelection) ? 5 : 1
        } else {
            return isFocused ? 4 : 1.5
        }
    }

    private var badgeFillColor: Color {
        if isRevealed && (isCorrect || isWrongSelection) {
            return Color.white
        }
        return isFocused ? Color.white : Color.white.opacity(0.18)
    }

    var body: some View {
        Button(action: {
            guard !isRevealed else { return }
            action()
        }) {
            HStack(spacing: 24) {
                // Letter badge (A, B, C, D)
                ZStack {
                    Circle()
                        .fill(badgeFillColor)
                        .frame(width: 58, height: 58)

                    if isRevealed && isCorrect {
                        Image(systemName: "checkmark")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.green)
                    } else if isRevealed && isWrongSelection {
                        Image(systemName: "xmark")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(.red)
                    } else {
                        Text(letterIndex)
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(isFocused ? .black : .white)
                    }
                }

                // Answer choice text
                Text(text)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                // Status indicator icon when revealed
                if isRevealed {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    } else if isWrongSelection {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 22)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .background(cardBackground)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .opacity(isRevealed && !isCorrect && !isWrongSelection ? 0.35 : 1.0)
            .scaleEffect(isFocused && !isRevealed ? 1.05 : 1.0)
            .shadow(
                color: isRevealed && isCorrect ? Color.green.opacity(0.6) :
                       isRevealed && isWrongSelection ? Color.red.opacity(0.6) :
                       isFocused ? Color.white.opacity(0.4) : Color.black.opacity(0.2),
                radius: isFocused || (isRevealed && (isCorrect || isWrongSelection)) ? 26 : 8,
                x: 0,
                y: isFocused ? 10 : 4
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.72), value: isFocused)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Player Turn HUD Chip View
struct PlayerChipView: View {
    let player: Player
    let isCurrentTurn: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(player.themeColor)
                    .frame(width: 44, height: 44)
                Image(systemName: player.avatarIcon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(player.name)
                        .font(.system(size: 20, weight: isCurrentTurn ? .black : .bold))
                        .foregroundColor(.white)
                    if isCurrentTurn {
                        Text("• TURN")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(player.themeColor)
                    }
                }

                Text("\(player.score) PTS")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.85))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(isCurrentTurn ? player.themeColor.opacity(0.25) : Color.white.opacity(0.08))
                .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isCurrentTurn ? player.themeColor : Color.white.opacity(0.12),
                    lineWidth: isCurrentTurn ? 3.5 : 1
                )
        )
        .scaleEffect(isCurrentTurn ? 1.05 : 1.0)
        .shadow(
            color: isCurrentTurn ? player.themeColor.opacity(0.55) : Color.clear,
            radius: 16,
            x: 0,
            y: 4
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCurrentTurn)
    }
}

// MARK: - High-Performance Confetti Particle View
struct ConfettiView: View {
    @State private var animate = false

    private let confettiCount = 36
    private let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange, .cyan]

    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { i in
                ConfettiPiece(
                    color: colors[i % colors.count],
                    index: i,
                    animate: animate
                )
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.easeOut(duration: 3.0)) {
                    animate = true
                }
            }
        }
    }

    private struct ConfettiPiece: View {
        let color: Color
        let index: Int
        let animate: Bool

        private var startX: CGFloat {
            CGFloat((index * 47) % 1800) + 60
        }

        private var endY: CGFloat {
            CGFloat(950 + (index * 17) % 300)
        }

        private var rotation: Double {
            Double((index * 67) % 720)
        }

        var body: some View {
            Rectangle()
                .fill(color)
                .frame(width: CGFloat(10 + (index % 8)), height: CGFloat(16 + (index % 12)))
                .cornerRadius(3)
                .offset(
                    x: (startX - 960) + (animate ? CGFloat((index % 2 == 0 ? 1 : -1) * ((index * 13) % 120)) : 0),
                    y: animate ? (endY - 540) : -600
                )
                .rotationEffect(.degrees(animate ? rotation : 0))
                .opacity(animate ? 0.0 : 1.0)
        }
    }
}
