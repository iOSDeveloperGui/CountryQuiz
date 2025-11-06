//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation
import SwiftUI

@MainActor
final class QuizViewModel: ObservableObject, GameTimeDelegate{
    
    //MARK: - Property (DI)
    private let countryService: CountryService
    private let questionGenerator: QuestionGenerator
    private let gameTimer: GameTimer
    private let difficulty: Difficulty
    private let onGameOver: (Int) -> Void
    
    init(countryService: CountryService, questionGenerator: QuestionGenerator, gameTimer: GameTimer, difficulty: Difficulty, onGameOver: @escaping (Int) -> Void){
        self.countryService = countryService
        self.questionGenerator = questionGenerator
        self.gameTimer = gameTimer
        self.difficulty = difficulty
        self.onGameOver = onGameOver
        self.gameTimer.delegate = self
    }
    
    //MARK: - @Published UI State
    @Published var currentQuestion: QuizQuestion?
    @Published var isLoading: Bool = true
    @Published var hearts = 5
    @Published var score = 0
    @Published var showAnswerFeedback: Bool? = nil
    @Published var bannerText: String? = nil
    @Published var selectedAnswer: String? = nil
    @Published var timeRemaining = 10
    @Published var currentQuestionIndex: Int = 0
    @Published var isDataLoaded: Bool = false
    
    //MARK: - Computed properties
    var difficultName: String{
        return difficulty.rawValue.capitalized
    }
    
    var totalQuestions: Int{
        return self.countries.count
    }
    
    var currentStage: String{
        let current = currentQuestionIndex + 1
        return "Question \(current) of \(totalQuestions)"
    }
    
    //MARK: - Private Properties
    public var countries: [Country] = []
    private let bannerMessages: [String] = ["Awesome! 😁", "Good job! 😀", "Great! 😀"]
    
    //MARK: - Functions
    public func loadData() async{
        guard !isDataLoaded else { return }
        
        do{
            let fetchedCountries = try await countryService.fetchCountries()
            
            let requiredCountryCount = self.difficulty.requiredCountryCount
            let filteredCountries = fetchedCountries.shuffled().prefix(requiredCountryCount)
            
            self.countries = Array(filteredCountries)
            
            if self.countries.count >= 4{
                generateQuestion()
                isLoading = false
                isDataLoaded = true
            } else{
                isLoading = false
            }
        } catch{
            print("Error loading the countries: \(error.localizedDescription)")
        }
    }
    
    public func checkAnswer(answer: String){
        guard let correct = currentQuestion?.correctAnswer else { return }
        
        gameTimer.cancel()
        selectedAnswer = answer
        
        if answer == correct{
            handleCorrectAnswer()
        } else{
            handleIncorrectAnswer()
        }
    }
    
    func timerDidUpdate(timeRemaining: Int) {
        self.timeRemaining = timeRemaining
    }
    
    func timerDidfinish() {
        handleTimeUp()
    }
    
    public func generateQuestion(){
        guard let newQuestion = questionGenerator.generateQuestion(from: countries) else{
            return
        }
        
        currentQuestion = newQuestion
        selectedAnswer = nil
        showAnswerFeedback = nil
        
        if currentQuestionIndex < totalQuestions{
            currentQuestionIndex += 1
        }
        
        gameTimer.startTimer(seconds: 30)
    }
    
    
    private func handleCorrectAnswer(){
        score += 5
        showAnswerFeedback = true
        bannerText = bannerMessages.randomElement() ?? "Awesome!"
        
        Task{
            do{
                try await Task.sleep(nanoseconds: 800_000_000)
                await MainActor.run{
                    self.bannerText = nil
                    self.generateQuestion()
                }
            }
        }
    }
    
    private func handleIncorrectAnswer(){
        hearts = max(0, hearts - 1)
        showAnswerFeedback = false
        bannerText = "Try Again! 💡"
        
        Task{
            do{
                try await Task.sleep(nanoseconds: 800_000_000)
                await MainActor.run{
                    bannerText = nil
                    showAnswerFeedback = nil
                    selectedAnswer = nil
                    
                    if self.hearts == 0{
                        self.onGameOver(self.score)
                    } else{
                        self.gameTimer.startTimer(seconds: self.timeRemaining)
                    }
                }
            }
        }
    }

    private func handleTimeUp() {
        hearts = max(0, hearts - 1)
        
        if hearts == 0 {
            onGameOver(score)
        } else {
            generateQuestion()
        }
    }
    
    
}




