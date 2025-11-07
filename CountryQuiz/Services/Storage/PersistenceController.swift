//
//  PersistenceController.swift
//  CountryQuiz
//
//  Created by iOS Developer on 06/11/25.
//

import Foundation
import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        return controller
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GameScore")
        
        container.loadPersistentStores(completionHandler: { [self] (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error loading persistent stores: \(error), \(error.userInfo)")
            }
            
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        })
    }
    
}
