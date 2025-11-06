//
//  Difficulty.swift
//  CountryQuiz
//
//  Created by iOS Developer on 05/11/25.
//

import Foundation

enum Difficulty: String, CaseIterable{
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var requiredCountryCount: Int{
        switch self{
        case .easy:
            return 10
        case .medium:
            return 30
        case .hard:
            return 50
        }
    }
}
