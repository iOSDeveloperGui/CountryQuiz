//
//  ScreenEnum.swift
//  CountryQuiz
//
//  Created by iOS Developer on 28/10/25.
//

import Foundation

enum Screen{
    case splash
    case levelSelect(LevelViewModel)
    case quiz(QuizViewModel)
    case gameOver(score: Int)
    
}
