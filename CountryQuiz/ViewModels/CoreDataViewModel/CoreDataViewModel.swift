//
//  CoreDataViewModel.swift
//  CountryQuiz
//
//  Created by iOS Developer on 06/11/25.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
final class CoreDataViewModel: ObservableObject{
    @Published var scores: [GameScore] = []
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchHighScores()
    }
    
    func fetchHighScores(){
        viewContext.performAndWait {
            let request: NSFetchRequest<GameScore> = GameScore.fetchRequest()
            
            let scoreSort = NSSortDescriptor(keyPath: \GameScore.score, ascending: false)
            let dateSort = NSSortDescriptor(keyPath: \GameScore.date, ascending: false)
            request.sortDescriptors = [scoreSort, dateSort]
            
            do{
                self.scores = try viewContext.fetch(request)
            } catch{
                print("Error fetching scores: \(error.localizedDescription)")
                self.scores = []
            }
        }
    }
    
    func saveScore(score: Int, travellerName: String, travellerImage: String){
        guard let coordinator = viewContext.persistentStoreCoordinator,
              !coordinator.persistentStores.isEmpty else {
            print("❌ WARNING: Attempted to save before persistent stores were loaded. Delaying save.")
            return
        }
        
        viewContext.perform { [weak self] in
            guard let self = self else { return }
            
            let newScore = GameScore(context: self.viewContext)
            newScore.score = Int64(score)
            newScore.date = Date()
            newScore.travellerName = travellerName
            newScore.travellerImage = travellerImage
            
            do{
                try self.viewContext.save()
                
                Task { @MainActor in
                    self.fetchHighScores()
                }
            } catch{
                print("Failed to save score: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAllScores(){
        guard let coordinator = viewContext.persistentStoreCoordinator,
              !coordinator.persistentStores.isEmpty else {
            print("❌ WARNING: Attempted to delete before persistent stores were loaded. Ignoring request.")
            return
        }
        
        viewContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameScore")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do{
                try self.viewContext.execute(batchDeleteRequest)
                try self.viewContext.save()
                
                Task { @MainActor in
                    self.scores = []
                }
            } catch{
                print("Error deleting scores: \(error.localizedDescription)")
            }
        }
    }
}
