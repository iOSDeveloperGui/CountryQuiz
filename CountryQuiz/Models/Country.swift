//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation

struct Country: Decodable{
    let name: Name
    let flags: Flags
    
    struct Name: Decodable{
        let common: String
    }
    
    struct Flags: Decodable{
        let png: String
    }
}
