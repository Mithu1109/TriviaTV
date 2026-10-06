//
//  GameViewModel.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    // MARK: - Game Setup
    @Published var selectedCategory: TriviaCategory = .all
    @Published var totalQuestionsCount: Int = 5
    @Published var timeLimitSeconds: Int = 15
    @Published var players: [Player] = [
        Player(name: "Player 1", avatarIcon: "person.crop.circle.fill", colorIndex: 0)
    ]

    // MARK: - Active Match State
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var currentPlayerIndex: Int = 0
    @Published var timeRemaining: Int = 15
    @Published var selectedAnswerIndex: Int? = nil
    @Published var isAnswerRevealed: Bool = false
    @Published var isCorrectAnswer: Bool = false
    @Published var showConfetti: Bool = false
    @Published var isGameFinished: Bool = false
    @Published var pointsEarnedThisTurn: Int = 0
    @Published var autoAdvanceCountdown: Int = 3

    private var countdownTimer: AnyCancellable?
    private var transitionTimer: AnyCancellable?

    // MARK: - Computed Properties
    var currentQuestion: TriviaQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var currentPlayer: Player {
        guard !players.isEmpty else {
            return Player(name: "Player 1", avatarIcon: "person.crop.circle.fill", colorIndex: 0)
        }
        return players[currentPlayerIndex % players.count]
    }

    var sortedStandings: [Player] {
        players.sorted { (p1, p2) in
            if p1.score != p2.score {
                return p1.score > p2.score
            }
            return p1.correctCount > p2.correctCount
        }
    }

    var winner: Player? {
        sortedStandings.first
    }

    // MARK: - Game Configuration Helpers
    func setPlayerCount(_ count: Int) {
        let avatarIcons = [
            "gamecontroller.fill",
            "tv.fill",
            "sparkles",
            "bolt.fill"
        ]

        var newPlayers: [Player] = []
        for i in 0..<count {
            if i < players.count {
                newPlayers.append(players[i])
            } else {
                newPlayers.append(
                    Player(
                        name: "Player \(i + 1)",
                        avatarIcon: avatarIcons[i % avatarIcons.count],
                        colorIndex: i
                    )
                )
            }
        }
        self.players = newPlayers
    }

    // MARK: - Game Lifecycle
    func startMatch() {
        stopAllTimers()
        // Reset player scores
        for i in 0..<players.count {
            players[i].score = 0
            players[i].correctCount = 0
            players[i].totalAnswered = 0
        }

        // Fetch questions
        self.questions = TriviaDataService.shared.fetchQuestions(
            for: selectedCategory,
            count: totalQuestionsCount
        )

        self.currentQuestionIndex = 0
        self.currentPlayerIndex = 0
        self.isGameFinished = false
        self.selectedAnswerIndex = nil
        self.isAnswerRevealed = false
        self.showConfetti = false
        self.pointsEarnedThisTurn = 0

        loadQuestion()
    }

    private func loadQuestion() {
        stopAllTimers()
        self.selectedAnswerIndex = nil
        self.isAnswerRevealed = false
        self.showConfetti = false
        self.pointsEarnedThisTurn = 0
        self.timeRemaining = timeLimitSeconds

        startCountdownTimer()
    }

    private func startCountdownTimer() {
        countdownTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard !self.isAnswerRevealed else { return }

                if self.timeRemaining > 1 {
                    self.timeRemaining -= 1
                    if self.timeRemaining <= 4 {
                        SoundManager.shared.playTimerTick()
                    }
                } else {
                    self.timeRemaining = 0
                    self.handleTimeout()
                }
            }
    }

    // MARK: - Answer Handling
    func selectAnswer(at index: Int) {
        guard !isAnswerRevealed else { return }
        guard let question = currentQuestion else { return }

        stopAllTimers()
        selectedAnswerIndex = index
        let correct = (index == question.correctIndex)
        isCorrectAnswer = correct
        isAnswerRevealed = true

        // Update active player's performance
        var activePlayer = players[currentPlayerIndex % players.count]
        activePlayer.totalAnswered += 1

        if correct {
            // Speed bonus calculation: base 100 points + up to 50 speed bonus
            let speedBonus = timeRemaining * 3
            let totalTurnPoints = 100 + speedBonus
            self.pointsEarnedThisTurn = totalTurnPoints
            activePlayer.score += totalTurnPoints
            activePlayer.correctCount += 1
            showConfetti = true
            SoundManager.shared.playCorrectSound()
        } else {
            self.pointsEarnedThisTurn = 0
            showConfetti = false
            SoundManager.shared.playWrongSound()
        }

        players[currentPlayerIndex % players.count] = activePlayer

        scheduleNextQuestionTransition()
    }

    private func handleTimeout() {
        guard !isAnswerRevealed else { return }
        stopAllTimers()

        selectedAnswerIndex = nil
        isCorrectAnswer = false
        isAnswerRevealed = true
        showConfetti = false
        pointsEarnedThisTurn = 0

        var activePlayer = players[currentPlayerIndex % players.count]
        activePlayer.totalAnswered += 1
        players[currentPlayerIndex % players.count] = activePlayer

        SoundManager.shared.playWrongSound()
        scheduleNextQuestionTransition()
    }

    private func scheduleNextQuestionTransition() {
        autoAdvanceCountdown = 3
        transitionTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.autoAdvanceCountdown > 1 {
                    self.autoAdvanceCountdown -= 1
                } else {
                    self.advanceToNextTurn()
                }
            }
    }

    func advanceToNextTurn() {
        stopAllTimers()

        // Check if more questions remain
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            // Cycle player turn for multiplayer pass-and-play
            currentPlayerIndex = (currentPlayerIndex + 1) % players.count
            loadQuestion()
        } else {
            // Game Over -> Finish Match
            finishMatch()
        }
    }

    private func finishMatch() {
        stopAllTimers()
        isGameFinished = true
        SoundManager.shared.playVictorySound()

        // Save top player scores to persistent leaderboard
        for player in players {
            if player.score > 0 {
                LeaderboardStorage.shared.addEntry(
                    playerName: player.name,
                    score: player.score,
                    categoryName: selectedCategory.rawValue,
                    accuracy: player.accuracyPercentage
                )
            }
        }
    }

    private func stopAllTimers() {
        countdownTimer?.cancel()
        countdownTimer = nil
        transitionTimer?.cancel()
        transitionTimer = nil
    }

    func resetToCategories() {
        stopAllTimers()
        isGameFinished = false
        isAnswerRevealed = false
        currentQuestionIndex = 0
        currentPlayerIndex = 0
    }
}
