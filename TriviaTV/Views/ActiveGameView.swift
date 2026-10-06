//
//  ActiveGameView.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

struct ActiveGameView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var gameVM: GameViewModel
    @FocusState private var focusedOption: Int?
    @FocusState private var focusedActionButton: Bool?

    private let optionLetters = ["A", "B", "C", "D"]

    var body: some View {
        ZStack {
            AnimatedGradientBackground()

            if let question = gameVM.currentQuestion {
                VStack(spacing: 28) {
                    // MARK: - Top Bar
                    HStack(alignment: .center) {
                        // Category Pill Badge
                        HStack(spacing: 12) {
                            Image(systemName: question.category.iconName)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(question.category.primaryColor)
                            Text(question.category.rawValue)
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.1))
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())

                        Spacer()

                        // Question Round Indicator (e.g. Question 3 of 5)
                        HStack(spacing: 8) {
                            Text("ROUND")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.cyan)
                            Text("\(gameVM.currentQuestionIndex + 1)")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text("OF \(gameVM.questions.count)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.3))
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())

                        Spacer()

                        // Live Visual Countdown Timer
                        CircularTimerView(
                            timeRemaining: gameVM.timeRemaining,
                            totalTime: gameVM.timeLimitSeconds
                        )
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 16)

                    // MARK: - Center Stage: Question Card
                    VStack(spacing: 12) {
                        Text(question.questionText)
                            .font(.system(size: 44, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .minimumScaleFactor(0.85)
                            .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)

                        // Explanation & Fact reveal during answer transition
                        if gameVM.isAnswerRevealed {
                            HStack(spacing: 12) {
                                Image(systemName: gameVM.isCorrectAnswer ? "star.fill" : "info.circle.fill")
                                    .foregroundColor(gameVM.isCorrectAnswer ? .yellow : .cyan)
                                Text(question.explanation)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.4))
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.06))
                            .background(RoundedRectangle(cornerRadius: 28).fill(.ultraThinMaterial))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(
                                gameVM.isAnswerRevealed ?
                                    (gameVM.isCorrectAnswer ? Color.green.opacity(0.8) : Color.red.opacity(0.8)) :
                                    Color.white.opacity(0.15),
                                lineWidth: gameVM.isAnswerRevealed ? 3 : 1
                            )
                    )
                    .padding(.horizontal, 60)

                    // MARK: - The Options Grid (Deterministic 2x2 Grid)
                    VStack(spacing: 24) {
                        HStack(spacing: 28) {
                            if question.options.indices.contains(0) {
                                answerCard(for: question, index: 0)
                            }
                            if question.options.indices.contains(1) {
                                answerCard(for: question, index: 1)
                            }
                        }
                        if question.options.count > 2 {
                            HStack(spacing: 28) {
                                if question.options.indices.contains(2) {
                                    answerCard(for: question, index: 2)
                                }
                                if question.options.indices.contains(3) {
                                    answerCard(for: question, index: 3)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 60)

                    Spacer(minLength: 0)

                    // MARK: - Results Transition Banner or Turn/Player HUD
                    if gameVM.isAnswerRevealed {
                        // Reveal Action Bar (Next Turn Countdown / Manual Next)
                        HStack(spacing: 30) {
                            HStack(spacing: 14) {
                                if gameVM.isCorrectAnswer {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.green)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("CORRECT! +\(gameVM.pointsEarnedThisTurn) PTS")
                                            .font(.system(size: 26, weight: .black, design: .rounded))
                                            .foregroundColor(.green)
                                        Text("\(gameVM.currentPlayer.name) takes the lead!")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color.white.opacity(0.8))
                                    }
                                } else {
                                    Image(systemName: "xmark.seal.fill")
                                        .font(.system(size: 32))
                                        .foregroundColor(.red)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("INCORRECT")
                                            .font(.system(size: 26, weight: .black, design: .rounded))
                                            .foregroundColor(.red)
                                        Text("Correct answer: \(question.options[question.correctIndex])")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color.white.opacity(0.8))
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 14)
                            .background(Color.black.opacity(0.5))
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                            Spacer()

                            // Next Question Button
                            Button {
                                SoundManager.shared.playFocusClick()
                                withAnimation {
                                    gameVM.advanceToNextTurn()
                                    if !gameVM.isGameFinished {
                                        focusedOption = 0
                                    }
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Text(gameVM.currentQuestionIndex + 1 == gameVM.questions.count ? "See Final Scoreboard" : "Next Question")
                                        .font(.system(size: 24, weight: .heavy))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 22, weight: .bold))
                                    Text("(\(gameVM.autoAdvanceCountdown)s)")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color.black.opacity(0.7))
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(Color.yellow)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .buttonStyle(TvOSCardButtonStyle(cornerRadius: 20, activeBorderColor: .yellow))
                            .focused($focusedActionButton, equals: true)
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // MARK: - Turn / Player HUD (Simulated Local Turns)
                        HStack(spacing: 24) {
                            Text("PLAYERS:")
                                .font(.system(size: 18, weight: .heavy))
                                .foregroundColor(Color.white.opacity(0.5))

                            ForEach(0..<gameVM.players.count, id: \.self) { idx in
                                PlayerChipView(
                                    player: gameVM.players[idx],
                                    isCurrentTurn: idx == (gameVM.currentPlayerIndex % gameVM.players.count)
                                )
                            }

                            Spacer()

                            // Siri Remote Tip
                            HStack(spacing: 8) {
                                Image(systemName: "gamecontroller")
                                    .foregroundColor(.cyan)
                                Text("\(gameVM.currentPlayer.name)'s Turn")
                                    .font(.system(size: 20, weight: .heavy))
                                    .foregroundColor(.cyan)
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.cyan.opacity(0.15))
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 20)
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: gameVM.isAnswerRevealed)
            } else {
                ProgressView("Preparing Trivia Match...")
                    .font(.title)
            }

            // Confetti Overlay for Correct Answers
            if gameVM.showConfetti {
                ConfettiView()
            }
        }
        .onAppear {
            if focusedOption == nil {
                focusedOption = 0
            }
        }
        .onChange(of: gameVM.currentQuestionIndex) { _ in
            focusedOption = 0
        }
        .onChange(of: gameVM.isGameFinished) { finished in
            if finished {
                navigationPath.append(AppRoute.scoreboard)
            }
        }
        .onChange(of: gameVM.isAnswerRevealed) { revealed in
            if revealed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        focusedActionButton = true
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func answerCard(for question: TriviaQuestion, index idx: Int) -> some View {
        let optionText = question.options[idx]
        let letter = idx < optionLetters.count ? optionLetters[idx] : "\(idx + 1)"
        let isSelected = gameVM.selectedAnswerIndex == idx
        let isCorrect = (idx == question.correctIndex)
        let isWrongSelection = isSelected && !isCorrect

        AnswerOptionCardView(
            letterIndex: letter,
            text: optionText,
            isSelected: isSelected,
            isCorrect: isCorrect,
            isRevealed: gameVM.isAnswerRevealed,
            isWrongSelection: isWrongSelection
        ) {
            // Immediate state change so results appear with ZERO lag
            gameVM.selectAnswer(at: idx)
        }
        .focused($focusedOption, equals: idx)
    }
}
