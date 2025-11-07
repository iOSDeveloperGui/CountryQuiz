//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import SwiftUI

@main
struct CountryQuizApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var appState = AppState(
        context: PersistenceController.shared.container.viewContext
    )
    @StateObject private var coreDataViewModel = CoreDataViewModel(viewContext: PersistenceController.shared.container.viewContext)
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView()
                .environmentObject(appState)
                .environmentObject(coreDataViewModel) 
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
