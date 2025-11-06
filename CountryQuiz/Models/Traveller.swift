//
//  Character.swift
//  CountryQuiz
//
//  Created by iOS Developer on 26/08/25.
//

import Foundation

struct Traveller: Identifiable, Equatable{
    let id: UUID
    let name: String
    let description: String
    let image: String
    
    init(id: UUID = UUID(), name: String, description: String, image: String) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
    }
    
}


