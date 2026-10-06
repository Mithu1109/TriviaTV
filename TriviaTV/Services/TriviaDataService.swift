//
//  TriviaDataService.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import Foundation

struct TriviaDataService {
    static let shared = TriviaDataService()

    private let allQuestions: [TriviaQuestion] = [
        // MARK: - Tech & Gaming Trivia
        TriviaQuestion(
            category: .techGaming,
            questionText: "Which Apple operating system is designed specifically for spatial computing?",
            options: ["tvOS", "watchOS", "visionOS", "macOS"],
            correctIndex: 2,
            explanation: "visionOS powers Apple Vision Pro, introducing infinite 3D spatial computing."
        ),
        TriviaQuestion(
            category: .techGaming,
            questionText: "What was the very first video game console released for home televisions in 1972?",
            options: ["Atari 2600", "Magnavox Odyssey", "Nintendo Famicom", "Coleco Telstar"],
            correctIndex: 1,
            explanation: "The Magnavox Odyssey, invented by Ralph Baer, was the world's first commercial home console."
        ),
        TriviaQuestion(
            category: .techGaming,
            questionText: "Which company created the iconic handheld console Game Boy in 1989?",
            options: ["Sega", "Sony", "Nintendo", "Bandai"],
            correctIndex: 2,
            explanation: "Gunpei Yokoi and Nintendo R&D1 designed the legendary Game Boy."
        ),
        TriviaQuestion(
            category: .techGaming,
            questionText: "In Apple history, what breakthrough chip architecture debuted in Macs in late 2020?",
            options: ["Apple A14 Bionic", "Apple M1", "Intel Core i9", "PowerPC G5"],
            correctIndex: 1,
            explanation: "The Apple M1 chip marked the transition of Mac computers to Apple Silicon."
        ),
        TriviaQuestion(
            category: .techGaming,
            questionText: "In Minecraft, which ultra-rare ore was introduced as stronger and more heat-resistant than Diamond?",
            options: ["Netherite", "Obsidian", "Redstone", "Amethyst"],
            correctIndex: 0,
            explanation: "Netherite armor and tools float in lava and provide superior knockback resistance."
        ),
        TriviaQuestion(
            category: .techGaming,
            questionText: "Which programming language was created by Apple in 2014 to replace Objective-C?",
            options: ["Kotlin", "Rust", "Swift", "Dart"],
            correctIndex: 2,
            explanation: "Swift was introduced at WWDC 2014 as a modern, fast, and type-safe language."
        ),
        TriviaQuestion(
            category: .techGaming,
            questionText: "What is the best-selling video game of all time with over 300 million copies sold?",
            options: ["Tetris", "Grand Theft Auto V", "Minecraft", "Wii Sports"],
            correctIndex: 2,
            explanation: "Minecraft officially surpassed 300 million copies sold worldwide."
        ),
        TriviaQuestion(
            category: .techGaming,
            questionText: "What wireless technology was named after a 10th-century Scandinavian Viking king?",
            options: ["Wi-Fi", "Bluetooth", "NFC", "Zigbee"],
            correctIndex: 1,
            explanation: "Bluetooth was named after King Harald Bluetooth, who united Scandinavian tribes."
        ),

        // MARK: - World History & Geography
        TriviaQuestion(
            category: .history,
            questionText: "Which ancient civilization constructed the magnificent city of Machu Picchu high in the Andes?",
            options: ["Aztecs", "Mayans", "Incas", "Olmecs"],
            correctIndex: 2,
            explanation: "Machu Picchu was built by the Inca Empire under Emperor Pachacuti in the 15th century."
        ),
        TriviaQuestion(
            category: .history,
            questionText: "Which river is widely recognized as the longest river in the entire world?",
            options: ["Amazon River", "Nile River", "Yangtze River", "Mississippi River"],
            correctIndex: 1,
            explanation: "The Nile River stretches approximately 6,650 kilometers across northeastern Africa."
        ),
        TriviaQuestion(
            category: .history,
            questionText: "In which modern-day country would you find the ruins of ancient Babylon?",
            options: ["Egypt", "Iraq", "Turkey", "Iran"],
            correctIndex: 1,
            explanation: "Babylon was situated along the Euphrates River in what is present-day Iraq."
        ),
        TriviaQuestion(
            category: .history,
            questionText: "Which country has the greatest number of natural lakes in the world?",
            options: ["Canada", "Russia", "United States", "Finland"],
            correctIndex: 0,
            explanation: "Canada contains over 879,000 lakes, more than 60% of all natural lakes on Earth."
        ),
        TriviaQuestion(
            category: .history,
            questionText: "What famous historic wall was torn down in November 1989, symbolizing the end of the Cold War?",
            options: ["Great Wall of China", "Hadrian's Wall", "Berlin Wall", "Western Wall"],
            correctIndex: 2,
            explanation: "The fall of the Berlin Wall reunited East and West Germany and altered world history."
        ),
        TriviaQuestion(
            category: .history,
            questionText: "What is the capital city of Australia?",
            options: ["Sydney", "Melbourne", "Canberra", "Brisbane"],
            correctIndex: 2,
            explanation: "Canberra was chosen as a compromise capital between rivals Sydney and Melbourne in 1908."
        ),
        TriviaQuestion(
            category: .history,
            questionText: "Which European navigator was the first to sail directly from Europe around Africa to India?",
            options: ["Christopher Columbus", "Vasco da Gama", "Ferdinand Magellan", "James Cook"],
            correctIndex: 1,
            explanation: "Vasco da Gama reached Calicut, India in May 1498, opening the ocean spice route."
        ),
        TriviaQuestion(
            category: .history,
            questionText: "What is the largest desert on Earth by surface area?",
            options: ["Sahara Desert", "Arabian Desert", "Antarctic Polar Desert", "Gobi Desert"],
            correctIndex: 2,
            explanation: "Antarctica is officially the largest desert on Earth because of its low precipitation."
        ),

        // MARK: - Science & Nature
        TriviaQuestion(
            category: .science,
            questionText: "Which planet in our solar system spins backwards (clockwise) compared to most other planets?",
            options: ["Mars", "Venus", "Jupiter", "Neptune"],
            correctIndex: 1,
            explanation: "Venus has retrograde rotation, meaning the sun rises in the west and sets in the east."
        ),
        TriviaQuestion(
            category: .science,
            questionText: "What is the chemical symbol for Gold on the periodic table of elements?",
            options: ["Ag", "Fe", "Au", "Gd"],
            correctIndex: 2,
            explanation: "Au comes from the Latin word 'Aurum', meaning shining dawn."
        ),
        TriviaQuestion(
            category: .science,
            questionText: "How many hearts does an octopus have?",
            options: ["1", "2", "3", "4"],
            correctIndex: 2,
            explanation: "An octopus has three hearts: two pump blood to the gills and one pumps blood to the body."
        ),
        TriviaQuestion(
            category: .science,
            questionText: "What is the speed of light in a vacuum approximately in kilometers per second?",
            options: ["150,000 km/s", "300,000 km/s", "500,000 km/s", "1,000,000 km/s"],
            correctIndex: 1,
            explanation: "Light travels at roughly 299,792 kilometers per second in a vacuum."
        ),
        TriviaQuestion(
            category: .science,
            questionText: "Which gas makes up approximately 78% of the Earth's atmosphere?",
            options: ["Oxygen", "Carbon Dioxide", "Nitrogen", "Argon"],
            correctIndex: 2,
            explanation: "Nitrogen comprises about 78% of dry atmospheric air, followed by Oxygen at 21%."
        ),
        TriviaQuestion(
            category: .science,
            questionText: "What is the powerhouse organelle of eukaryotic cells responsible for producing ATP?",
            options: ["Ribosome", "Mitochondria", "Nucleus", "Endoplasmic Reticulum"],
            correctIndex: 1,
            explanation: "Mitochondria generate most of the chemical energy needed by the cell."
        ),
        TriviaQuestion(
            category: .science,
            questionText: "Which mammal is known to be the only one capable of true sustained flight?",
            options: ["Flying Squirrel", "Sugar Glider", "Bat", "Colugo"],
            correctIndex: 2,
            explanation: "Bats are the only mammals with true powered wing flight; others merely glide."
        ),
        TriviaQuestion(
            category: .science,
            questionText: "What is the hardest naturally occurring mineral on Earth?",
            options: ["Quartz", "Topaz", "Corundum", "Diamond"],
            correctIndex: 3,
            explanation: "Diamond rates 10 out of 10 on the Mohs mineral hardness scale."
        ),

        // MARK: - Pop Culture & Movies
        TriviaQuestion(
            category: .popCulture,
            questionText: "Which animated movie was the first fully computer-animated feature film in history?",
            options: ["Toy Story", "Shrek", "A Bug's Life", "Monsters, Inc."],
            correctIndex: 0,
            explanation: "Pixar and Disney released Toy Story in 1995, pioneering 3D CGI feature films."
        ),
        TriviaQuestion(
            category: .popCulture,
            questionText: "In the Marvel Cinematic Universe, what is the fictional metal mined in Wakanda?",
            options: ["Adamantium", "Vibranium", "Uru", "Mithril"],
            correctIndex: 1,
            explanation: "Vibranium absorbs kinetic energy and forms Black Panther's suit and Captain America's shield."
        ),
        TriviaQuestion(
            category: .popCulture,
            questionText: "Which actor voiced the genie in Disney's original 1992 animated masterpiece Aladdin?",
            options: ["Eddie Murphy", "Robin Williams", "Jim Carrey", "Billy Crystal"],
            correctIndex: 1,
            explanation: "Robin Williams delivered an unforgettable, largely improvised performance as Genie."
        ),
        TriviaQuestion(
            category: .popCulture,
            questionText: "What is the fictional name of the coffee shop where the characters frequently gather in 'Friends'?",
            options: ["Monk's Diner", "Central Perk", "The Roasted Bean", "MacLaren's"],
            correctIndex: 1,
            explanation: "Central Perk was the beloved Greenwich Village coffee shop featured throughout Friends."
        ),
        TriviaQuestion(
            category: .popCulture,
            questionText: "Who directed the sci-fi epics 'Inception', 'Interstellar', and 'Oppenheimer'?",
            options: ["Denis Villeneuve", "Steven Spielberg", "Christopher Nolan", "James Cameron"],
            correctIndex: 2,
            explanation: "Christopher Nolan is renowned for non-linear storytelling and practical cinematic effects."
        ),
        TriviaQuestion(
            category: .popCulture,
            questionText: "In 'Star Wars', what is the color of the Jedi Master Mace Windu's distinctive lightsaber?",
            options: ["Blue", "Green", "Purple", "Yellow"],
            correctIndex: 2,
            explanation: "Samuel L. Jackson personally requested a purple lightsaber so he could spot himself in battle."
        ),
        TriviaQuestion(
            category: .popCulture,
            questionText: "Which 1997 James Cameron film won 11 Oscars and made 'I'm the king of the world!' iconic?",
            options: ["Avatar", "Titanic", "Gladiator", "Braveheart"],
            correctIndex: 1,
            explanation: "Titanic tied the record with Ben-Hur and Lord of the Rings: Return of the King with 11 Academy Awards."
        ),
        TriviaQuestion(
            category: .popCulture,
            questionText: "What magical creature is Buckbeak in the Harry Potter universe?",
            options: ["Thestral", "Hippogriff", "Basilisk", "Phoenix"],
            correctIndex: 1,
            explanation: "Buckbeak is a majestic Hippogriff with the front legs, wings, and head of an eagle and body of a horse."
        )
    ]

    func fetchQuestions(for category: TriviaCategory, count: Int = 5) -> [TriviaQuestion] {
        let pool: [TriviaQuestion]
        if category == .all {
            pool = allQuestions
        } else {
            pool = allQuestions.filter { $0.category == category }
        }

        let shuffled = pool.shuffled()
        return Array(shuffled.prefix(count))
    }
}
