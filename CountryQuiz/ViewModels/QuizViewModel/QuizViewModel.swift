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
    private let coreDataVM: CoreDataViewModel
    private let travellerName: String
    private let travellerImage: String
    private let onGameOver: (Int) -> Void
    
    init(countryService: CountryService, questionGenerator: QuestionGenerator, gameTimer: GameTimer, difficulty: Difficulty, coreDataVM: CoreDataViewModel, travellerName: String, travellerImage: String, onGameOver: @escaping (Int) -> Void){
        self.countryService = countryService
        self.questionGenerator = questionGenerator
        self.gameTimer = gameTimer
        self.difficulty = difficulty
        self.coreDataVM = coreDataVM
        self.travellerName = travellerName
        self.travellerImage = travellerImage
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
    @Published var currentQuestionIndex: Int = 1
    @Published var isDataLoaded: Bool = false
    
    //MARK: - Computed properties
    var difficultName: String{
        return difficulty.rawValue.capitalized
    }
    
    var totalQuestions: Int{
        return self.countries.count
    }
    
    var currentStage: String{
        let current = min(currentQuestionIndex, totalQuestions)
        return "Questions: \(current) of \(totalQuestions)"
    }
    
    //MARK: - Private Properties
    public var countries: [Country] = []
    private var usedCountries: Set<String> = []
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
        gameTimer.cancel()
        self.timeRemaining = timeRemaining
    }
    
    func timerDidfinish() {
        handleTimeUp()
    }
    
    public func generateQuestion(){
        if currentQuestionIndex > totalQuestions{
            endGameAndSaveScore()
            return
        }
        
        guard let newQuestion = questionGenerator.generateQuestion(from: countries, excluding: usedCountries) else{
            endGameAndSaveScore()
            return
        }
        
        currentQuestion = newQuestion
        selectedAnswer = nil
        showAnswerFeedback = nil
        
        gameTimer.startTimer(seconds: 30)
    }
    
    
    private func handleCorrectAnswer(){
        if let countryName = currentQuestion?.correctAnswer{
            usedCountries.insert(countryName)
        }
        
        score += 5
        showAnswerFeedback = true
        bannerText = bannerMessages.randomElement() ?? "Awesome!"
        
        Task{
            do{
                try await Task.sleep(nanoseconds: 800_000_000)
                await MainActor.run{
                    self.bannerText = nil
                    self.currentQuestionIndex += 1
                    
                    if self.currentQuestionIndex > self.totalQuestions{
                        endGameAndSaveScore()
                    } else{
                        self.generateQuestion()
                    }
                }
            } catch {
                print("Task interrupted or failed.")
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
                        endGameAndSaveScore()
                    } else{
                        self.currentQuestionIndex += 1
                        generateQuestion()
                    }
                }
            } catch {
                print("Task interrupted or failed.")
            }
        }
    }

    private func handleTimeUp() {
        hearts = max(0, hearts - 1)
        bannerText = "Time's up! ⏳"
        
        Task{
            do{
                try await Task.sleep(nanoseconds: 800_000_000)
                await MainActor.run{
                    self.bannerText = nil
                    if hearts == 0{
                        endGameAndSaveScore()
                    } else {
                        self.currentQuestionIndex += 1
                        generateQuestion()
                    }
                }
                
            } catch{
                print("Task interrupted or failed.")
            }
        }

        
    }
    
    private func endGameAndSaveScore(){
        gameTimer.cancel()
        
        coreDataVM.saveScore(
            score: self.score,
            travellerName: self.travellerName,
            travellerImage: self.travellerImage
        )
        onGameOver(score)
    }
    
    
}




