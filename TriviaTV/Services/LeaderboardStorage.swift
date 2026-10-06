//
//  LeaderboardStorage.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import Foundation
import Combine

final class LeaderboardStorage: ObservableObject {
    static let shared = LeaderboardStorage()

    private let storageKey = "TriviaTV_Leaderboard_Entries"

    @Published var entries: [LeaderboardEntry] = []

    private init() {
        loadEntries()
    }

    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            self.entries = decoded.sorted(by: { $0.score > $1.score })
        } else {
            // Seed with classic family record scores for a rich initial 10-foot experience
            self.entries = [
                LeaderboardEntry(playerName: "Player 1", score: 500, categoryName: "Tech & Gaming Trivia", accuracyPercentage: 100, date: Date().addingTimeInterval(-86400 * 2)),
                LeaderboardEntry(playerName: "Quiz Master", score: 450, categoryName: "Science & Nature", accuracyPercentage: 90, date: Date().addingTimeInterval(-86400 * 5)),
                LeaderboardEntry(playerName: "Movie Buff", score: 400, categoryName: "Pop Culture & Movies", accuracyPercentage: 80, date: Date().addingTimeInterval(-86400 * 7)),
                LeaderboardEntry(playerName: "Explorer", score: 350, categoryName: "World History & Geography", accuracyPercentage: 70, date: Date().addingTimeInterval(-86400 * 10))
            ]
            save()
        }
    }

    func addEntry(playerName: String, score: Int, categoryName: String, accuracy: Int) {
        let newEntry = LeaderboardEntry(
            playerName: playerName,
            score: score,
            categoryName: categoryName,
            accuracyPercentage: accuracy,
            date: Date()
        )
        entries.append(newEntry)
        entries.sort(by: { $0.score > $1.score })
        if entries.count > 20 {
            entries = Array(entries.prefix(20))
        }
        save()
    }

    func clearLeaderboard() {
        entries.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
