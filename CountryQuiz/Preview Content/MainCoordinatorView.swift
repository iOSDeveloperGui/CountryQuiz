//
//  ContentView.swift
//  FunFlag
//
//  Created by iOS Developer on 11/08/25.
//

import SwiftUI

struct MainCoordinatorView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var coreDataViewModel: CoreDataViewModel
    
    var body: some View {
        switch appState.currentScreen {
        case .splash:
            SplashView()
            
        case .levelSelect(let viewModel):
            LevelView()
                .environmentObject(viewModel)
                
        case .quiz(let viewModel):
            QuizView()
                .environmentObject(viewModel)
                .environmentObject(coreDataViewModel)
            
        case .gameOver(let score):
            GameOverView(
                score: score,
                onRestart: {
                    self.appState.currentScreen = .levelSelect(LevelViewModel())
                }
            )
            .environmentObject(coreDataViewModel)
        }
        
    }
}


#Preview {
    let mockContext = PersistenceController.preview.container.viewContext
    let mockCoreDataViewModel = CoreDataViewModel(viewContext: mockContext)
    
    return MainCoordinatorView()
        .environmentObject(AppState(context: mockContext))
    
        .environmentObject(mockCoreDataViewModel)
    
        .environment(\.managedObjectContext, mockContext)
}
