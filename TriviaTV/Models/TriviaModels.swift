//
//  TriviaModels.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import SwiftUI

// MARK: - Category Definition
enum TriviaCategory: String, CaseIterable, Identifiable, Codable {
    case all = "Mixed Challenge"
    case history = "World History & Geography"
    case science = "Science & Nature"
    case popCulture = "Pop Culture & Movies"
    case techGaming = "Tech & Gaming Trivia"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .all: return "All Categories"
        case .history: return "History & Geo"
        case .science: return "Science & Nature"
        case .popCulture: return "Pop Culture"
        case .techGaming: return "Tech & Gaming"
        }
    }

    var iconName: String {
        switch self {
        case .all: return "sparkles"
        case .history: return "globe.americas.fill"
        case .science: return "brain.head.profile"
        case .popCulture: return "film.fill"
        case .techGaming: return "gamecontroller.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .all: return "Questions from every era, science, screen & game"
        case .history: return "Ancient wonders, world capitals & historical landmarks"
        case .science: return "Deep cosmos, physics wonders, earth & creature biology"
        case .popCulture: return "Cinema classics, streaming hits, music & icons"
        case .techGaming: return "Silicon breakthroughs, consoles, retro games & Apple"
        }
    }

    var primaryColor: Color {
        switch self {
        case .all: return Color(red: 0.95, green: 0.6, blue: 0.2)
        case .history: return Color(red: 0.2, green: 0.7, blue: 0.6)
        case .science: return Color(red: 0.35, green: 0.5, blue: 0.95)
        case .popCulture: return Color(red: 0.92, green: 0.3, blue: 0.6)
        case .techGaming: return Color(red: 0.65, green: 0.35, blue: 0.95)
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .all:
            return [Color(red: 0.95, green: 0.45, blue: 0.2), Color(red: 0.9, green: 0.2, blue: 0.6)]
        case .history:
            return [Color(red: 0.1, green: 0.65, blue: 0.65), Color(red: 0.1, green: 0.45, blue: 0.8)]
        case .science:
            return [Color(red: 0.2, green: 0.45, blue: 0.95), Color(red: 0.1, green: 0.75, blue: 0.85)]
        case .popCulture:
            return [Color(red: 0.95, green: 0.25, blue: 0.55), Color(red: 0.7, green: 0.15, blue: 0.65)]
        case .techGaming:
            return [Color(red: 0.55, green: 0.25, blue: 0.95), Color(red: 0.25, green: 0.45, blue: 0.95)]
        }
    }
}

// MARK: - Question Model
struct TriviaQuestion: Identifiable, Codable, Equatable {
    let id: UUID
    let category: TriviaCategory
    let questionText: String
    let options: [String]
    let correctIndex: Int
    let explanation: String

    init(
        id: UUID = UUID(),
        category: TriviaCategory,
        questionText: String,
        options: [String],
        correctIndex: Int,
        explanation: String
    ) {
        self.id = id
        self.category = category
        self.questionText = questionText
        self.options = options
        self.correctIndex = correctIndex
        self.explanation = explanation
    }
}

// MARK: - Player Model (Multiplayer Living Room HUD)
struct Player: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var avatarIcon: String
    var colorIndex: Int
    var score: Int = 0
    var correctCount: Int = 0
    var totalAnswered: Int = 0

    var accuracyPercentage: Int {
        guard totalAnswered > 0 else { return 0 }
        return Int((Double(correctCount) / Double(totalAnswered)) * 100.0)
    }

    var themeColor: Color {
        let colors: [Color] = [
            Color(red: 0.2, green: 0.6, blue: 1.0),   // Electric Blue
            Color(red: 1.0, green: 0.35, blue: 0.55), // Coral Pink
            Color(red: 0.3, green: 0.85, blue: 0.5),  // Emerald Green
            Color(red: 0.95, green: 0.75, blue: 0.2)  // Golden Amber
        ]
        return colors[colorIndex % colors.count]
    }
}

// MARK: - Leaderboard Entry Model
struct LeaderboardEntry: Identifiable, Codable {
    var id: UUID = UUID()
    let playerName: String
    let score: Int
    let categoryName: String
    let accuracyPercentage: Int
    let date: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Navigation Routes
enum AppRoute: Hashable {
    case categorySelection
    case activeGame
    case scoreboard
    case leaderboard
    case howToPlay
}
