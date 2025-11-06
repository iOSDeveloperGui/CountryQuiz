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
    
    func saveScore(score: Int, travellerName: String, travellerImage: String){
        let newScore = GameScore(context: viewContext)
        newScore.score = Int64(score)
        newScore.date = Date()
        newScore.travellerName = travellerName
        newScore.travellerImage = travellerImage
        
        do{
            try viewContext.save()
            self.fetchHighScores()
        } catch{
            print("Failed to save score: \(error.localizedDescription)")
        }
    }
    
    func deleteAllScores(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameScore")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do{
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
            self.scores = []
        } catch{
            print("Error deleting scores: \(error.localizedDescription)")
        }
    }
}
