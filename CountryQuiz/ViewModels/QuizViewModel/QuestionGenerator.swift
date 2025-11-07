//
//  QuestionGenerator.swift
//  CountryQuiz
//
//  Created by iOS Developer on 29/10/25.
//

import Foundation

struct QuestionGenerator{
    
    func generateQuestion(from countries: [Country], excluding usedCountries: Set<String>) -> QuizQuestion? {
        let availableCountries = countries.filter { !usedCountries.contains($0.name.common)}
        
        guard availableCountries.count >= 4 else { return nil }
        
        guard let correctCountry = availableCountries.randomElement() else { return nil }
        
        let pool = availableCountries.filter { $0.name.common != correctCountry.name.common }.shuffled()
        let incorrectOptions = pool.prefix(3).map { $0.name.common }
        
        let options = (incorrectOptions + [correctCountry.name.common]).shuffled()
        
        return QuizQuestion(
            imageURL: correctCountry.flags.png,
            options: options,
            correctAnswer: correctCountry.name.common
        )
    }
}
