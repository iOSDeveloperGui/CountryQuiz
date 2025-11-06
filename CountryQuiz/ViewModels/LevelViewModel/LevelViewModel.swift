//
//  LevelController.swift
//  CountryQuiz
//
//  Created by iOS Developer on 27/08/25.
//

import Foundation   

@MainActor
final class LevelViewModel: ObservableObject{
     
    public let travellers: [Traveller] = [
        Traveller(name: "James", description: "A loyal canine explorer, always ready to embark on new adventures with boundless energy", image: "characterTraveller3"),
        
        Traveller(name: "Tadeu", description: "A curious feline wanderer, agile and clever, who sneaks into mysterious places.", image: "characterTraveller2"),
        
        Traveller(name: "Rufus", description: "A gentle yet resilient traveller, always prepared with clever tricks hidden beneath his spines.", image: "characterTraveller"),
        
        Traveller(name: "Kelly", description: "A wise owl who travels under the stars", image: "characterTraveller4"),
        
        Traveller(name: "Ronaldo", description: "A gentle hippopotamus adventurer, strong and steady", image: "characterTraveller5"),
        
        Traveller(name: "Daniela", description: "A spirited weasel traveller, quick and clever.", image: "characterTraveller6")
    ]
    
    public let difficulties: [String] = Difficulty.allCases.map { $0.rawValue }
    
    
    
}
