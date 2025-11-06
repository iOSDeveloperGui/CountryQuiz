//
//  LoadError.swift
//  CountryQuiz
//
//  Created by iOS Developer on 06/11/25.
//

import Foundation

enum LoadError: String{
    case failedLoading
    
    var result: String{
        switch self{
        case .failedLoading:
            return "Error loading the next view"
        }
    }
}
