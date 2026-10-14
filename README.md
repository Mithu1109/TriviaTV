# TriviaTV 📺✨
> **A Living Room Family Trivia Challenge for Apple tvOS**

[![Platform](https://img.shields.io/badge/Platform-tvOS%2017%2B-blue.svg)](https://developer.apple.com/tvos/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org/)
[![Framework](https://img.shields.io/badge/UI-SwiftUI-red.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**TriviaTV** is a fast-paced, interactive family trivia game built natively for Apple TV. Designed for the 10-foot living room experience, it features Siri Remote focus navigation, pass-and-play multiplayer, high-energy visuals, sound synthesis, and instant zero-latency feedback.

---

## 🎮 Key Features

- **Living Room 10-Foot Design**:
  - Full Siri Remote focus navigation powered by custom SwiftUI focus states.
  - Large typography and high-contrast ambient gradients crafted for big-screen TVs.
- **Pass-and-Play Multiplayer (1–4 Players)**:
  - Dynamic turn HUD tracking current turn, player avatars, scores, and accuracy percentages.
  - Speed bonus scoring calculation (up to 50 extra points for fast answers).
- **Categories Across All Disciplines**:
  - 🌍 World History & Geography
  - 🔬 Science & Nature
  - 🎬 Pop Culture & Movies
  - 🕹️ Tech & Gaming Trivia
  - ✨ Mixed Challenge
- **Zero-Latency Instant Result Feedback**:
  - Deterministic 2x2 response cards with GPU-accelerated state transitions.
  - Smooth delayed focus transitions to the next action button without Focus Engine stalls.
- **Audio Synthesis Engine**:
  - Non-blocking, precomputed harmonic audio tone synthesizer using `AVAudioEngine`.
- **Persistent Leaderboard**:
  - High score tracking and local persistence.

---

## 🏗️ Architecture

```
TriviaTV/
├── TriviaTV.xcodeproj         # Xcode Project
├── TriviaTV/
│   ├── TriviaTVApp.swift      # App entry point
│   ├── ContentView.swift      # Main navigation stack
│   ├── Components/
│   │   └── TvOSFocusComponents.swift # Focus card buttons, gradients & confetti
│   ├── Models/
│   │   └── TriviaModels.swift        # Question, player & category data structures
│   ├── Services/
│   │   ├── SoundManager.swift        # Low-latency harmonic sound synthesis
│   │   ├── TriviaDataService.swift   # Curated questions database
│   │   └── LeaderboardStorage.swift  # Persistent player rankings
│   ├── ViewModels/
│   │   └── GameViewModel.swift       # State machine, scoring & timer controls
│   └── Views/
│       ├── ActiveGameView.swift      # 2x2 Quiz arena & live countdown HUD
│       ├── CategorySelectionView.swift# Match config & player selector
│       ├── HomeView.swift            # Main menu & quick start
│       ├── HowToPlayView.swift       # Rules & controller guidelines
│       ├── LeaderboardView.swift     # Hall of fame standings
│       └── ScoreboardView.swift      # Post-match celebration & winner podium
├── TriviaTVTests/                    # Unit tests
└── TriviaTVUITests/                  # UI automation tests
```

---

## 🚀 Getting Started

### Requirements
- **Xcode 15.0+**
- **tvOS 17.0+ SDK**
- **Apple TV 4K / Apple TV HD** or **tvOS Simulator**

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Mithu1109/TriviaTV.git
   ```
2. Open `TriviaTV.xcodeproj` in Xcode:
   ```bash
   open TriviaTV.xcodeproj
   ```
3. Select an Apple TV Simulator (e.g., Apple TV 4K) or a physical Apple TV device as the build target.
4. Press `Cmd + R` to build and run!

---

## 🎯 Controls (Siri Remote)
- **Clickpad Swipe**: Move focus across options and menu buttons.
- **Clickpad Click**: Select focused option / Confirm answer.
- **Back Button**: Navigate back to the previous screen.

---

## 📄 License
This project is licensed under the MIT License.
