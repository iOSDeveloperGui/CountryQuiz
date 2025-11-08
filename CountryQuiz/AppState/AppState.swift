//
//  AppState.swift
//  CountryQuiz
//
//  Created by iOS Developer on 28/10/25.
//

import Foundation
import CoreData

@MainActor
class AppState: ObservableObject{
    
    @Published var currentScreen: Screen = .splash
    @Published var selectedCharacter: Traveller?
    @Published var showingInfoSheet: Bool = false
    
    private let countryService: CountryService
    private let questionGenerator: QuestionGenerator
    let coreDataVM: CoreDataViewModel
    
    private let levelViewModel: LevelViewModel
    
    init(context: NSManagedObjectContext){
        let serviceData = CountryServiceData()
        self.countryService = CountryService(countryServiceData: serviceData)
        self.questionGenerator = QuestionGenerator()
        self.coreDataVM = CoreDataViewModel(viewContext: context)
        self.levelViewModel = LevelViewModel()
        self.currentScreen = .splash
    }
    
    public func showInfo(){
        if case .splash = currentScreen {
            self.showingInfoSheet = true
        }
        
    }
    
    public func startLevelSelect(){
        showingInfoSheet = false
        
        let levelVM = LevelViewModel()
        self.currentScreen = .levelSelect(levelVM)
        
    }
    
    public func startQuiz(difficulty difficultyString: String){
        guard let difficulty = Difficulty(rawValue: difficultyString) else {
            print("Invalid difficulty string")
            return
        }
        
        let quizViewModel = QuizViewModel(
            countryService: countryService,
            questionGenerator: questionGenerator,
            gameTimer: GameTimer(),
            difficulty: difficulty,
            coreDataVM: coreDataVM,
            travellerName: self.selectedCharacter?.name ?? "Guest Player",
            travellerImage: self.selectedCharacter?.image ?? "person.crop.circle",
            onGameOver: { [ weak self ] finalScore in
                self?.showGameOver(score: finalScore)
            })
        currentScreen = .quiz(quizViewModel)
    }
    
    public func showGameOver(score: Int){
        currentScreen = .gameOver(score: score)
    }
    
    public func restartToLevelSelect(){
        currentScreen = .levelSelect(levelViewModel)
    }
    
    
}
