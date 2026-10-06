//
//  TriviaTVTests.swift
//  TriviaTVTests
//
//  Created for TriviaTV: Family Challenge
//

import XCTest
@testable import TriviaTV

final class TriviaTVTests: XCTestCase {

    func testQuestionDataServiceFetchesCorrectCategories() {
        let techQuestions = TriviaDataService.shared.fetchQuestions(for: .techGaming, count: 5)
        XCTAssertEqual(techQuestions.count, 5)
        for q in techQuestions {
            XCTAssertEqual(q.category, .techGaming)
            XCTAssertEqual(q.options.count, 4)
            XCTAssertTrue(q.correctIndex >= 0 && q.correctIndex < 4)
        }
    }

    func testVisionOSQuestionExistsInService() {
        let techQuestions = TriviaDataService.shared.fetchQuestions(for: .techGaming, count: 20)
        let spatialQuestion = techQuestions.first { $0.questionText.contains("spatial computing") }
        XCTAssertNotNil(spatialQuestion)
        if let q = spatialQuestion {
            XCTAssertEqual(q.options[q.correctIndex], "visionOS")
        }
    }

    @MainActor
    func testGameViewModelScoreAndTurnProgression() {
        let vm = GameViewModel()
        vm.setPlayerCount(2)
        XCTAssertEqual(vm.players.count, 2)
        XCTAssertEqual(vm.currentPlayer.name, "Player 1")

        vm.startMatch()
        XCTAssertEqual(vm.currentQuestionIndex, 0)
        XCTAssertEqual(vm.currentPlayerIndex, 0)

        guard let firstQuestion = vm.currentQuestion else {
            XCTFail("Questions should not be empty")
            return
        }

        // Answer correctly
        vm.selectAnswer(at: firstQuestion.correctIndex)
        XCTAssertTrue(vm.isCorrectAnswer)
        XCTAssertTrue(vm.isAnswerRevealed)
        XCTAssertGreaterThanOrEqual(vm.players[0].score, 100)
        XCTAssertEqual(vm.players[0].correctCount, 1)

        // Advance to next turn
        vm.advanceToNextTurn()
        XCTAssertEqual(vm.currentQuestionIndex, 1)
        XCTAssertEqual(vm.currentPlayerIndex, 1)
        XCTAssertEqual(vm.currentPlayer.name, "Player 2")
    }

    func testLeaderboardStorageSorting() {
        let storage = LeaderboardStorage.shared
        storage.addEntry(playerName: "TestChampion", score: 9999, categoryName: "Mixed Challenge", accuracy: 100)
        XCTAssertEqual(storage.entries.first?.playerName, "TestChampion")
        XCTAssertEqual(storage.entries.first?.score, 9999)
    }
}
