# 🌍 Country Quiz: Flag Explorer
  A fun, engaging quiz application built with SwiftUI and Core Data, challenging users to identify country flags based on chosen difficulty and track their progress through a high score system.

<img width="400" height="3408" alt="iPhone 16 - 2" src="https://github.com/user-attachments/assets/248632b8-042a-4cd6-8be1-cebdf053f3ec" />
<img width="400" height="3408" alt="iPhone 16 - 1" src="https://github.com/user-attachments/assets/a2aae6e9-2254-4d5a-876f-4b37986be8ff" />




<img width="212" height="399" alt="image" src="https://github.com/user-attachments/assets/85221f70-ba9b-4f76-8d73-1552a35ab67e" />
<img width="217" height="394" alt="image" src="https://github.com/user-attachments/assets/0339b116-a165-4784-acfa-910b9a82bea3" />
<img width="216" height="397" alt="image" src="https://github.com/user-attachments/assets/f0015f9f-ee18-4a68-9f5b-d48f4f1dab0b" />



## Features:

* **Modular Architecture:** Uses the Coordinator pattern (`MainCoordinatorView` and `AppState`) for clear, decoupled navigation.
* **Customizable Quizzes:** Users can select a traveler character and choose a difficulty level (Easy, Medium, Hard).
* **Real-Time Feedback:** Tracks score, hearts, and time remaining during the quiz (`QuizView`).
* **Persistent High Scores:** Utilizes **Core Data** (`CoreDataViewModel`) to locally save and retrieve global high scores, visible after a game ends.
* **Asynchronous Data Loading:** Handles fetching of flag data (presumably from a local JSON or API) asynchronously.

## 🏗️ Project Structure Highlights

| File/Component | Role |
| :--- | :--- |
| `MainCoordinatorView.swift` | Root view, manages application state (`AppState`), and switches between screens (Splash, Level Select, Quiz, Game Over). |
| `AppState.swift` | Observable object defining the current screen state (`.quiz`, `.gameOver`, etc.). |
| `LevelView.swift` | Allows character selection and difficulty selection. |
| `QuizView.swift` | Main game view. Handles question display, user input, and game logic (`QuizViewModel`). |
| `GameOverView.swift` | Displays final score and allows restarting the quiz or viewing high scores. |
| `CoreDataView.swift` | Presents the persistent high scores list, managed by `CoreDataViewModel`. |
| `CoreDataViewModel.swift` | Handles all Core Data operations (saving new scores, fetching existing scores). |

## 🚀 Getting Started

### Prerequisites

* Xcode (latest version recommended)
* iOS 17.0+ (or compatible version targeted in your project settings)

### Installation

1.  **Clone the Repository:**
    ```bash
    git clone [Your Repository URL]
    cd [your-project-name]
    ```

2.  **Open in Xcode:**
    ```bash
    open [YourProjectName].xcodeproj
    ```

3.  **Core Data Setup:**
    * Ensure your Core Data model (`.xcdatamodeld`) is set up with the `Score` entity, including attributes like `score`, `travellerName`, `travellerImage`, and `date`.
    * Verify the `PersistenceController` is correctly initialized in your main App file.

4.  **Run:**
    * Select a simulator or device.
    * Press **CMD + R** to build and run the application.

## ⚙️ Key Logic and Coordination

The application flow is driven by the interaction between `MainCoordinatorView` and `AppState`:

1.  **Start Quiz:** `LevelView` sets `AppState.currentScreen` to `.quiz(viewModel)`.
2.  **Game Over & Saving:**
    * The `QuizView` detects `viewModel.isGameOver` becoming `true`.
    * It triggers the `onGameOver` closure passed from `MainCoordinatorView`.
    * `MainCoordinatorView` executes **`coreDataViewModel.saveScore(...)`** to persist the result.
    * `MainCoordinatorView` then sets `AppState.currentScreen` to `.gameOver(score)`.
3.  **View High Scores:** The "View High Scores" button in `GameOverView` presents `CoreDataView` as a sheet, which immediately calls `viewModel.fetchHighScores()` to load the saved data.

## 🤝 Contributing

(Optional: Use this section if you plan on collaborating)

1.  Fork the repository.
2.  Create a new feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
