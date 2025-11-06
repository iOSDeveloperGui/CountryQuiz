//
//  FlagApiError .swift
//  FunFlag
//
//  Created by iOS Developer on 11/08/25.
//

import Foundation

enum FlagApiError: Error{
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    
    var errorDescription: String? {
        switch self{
        case .invalidURL:
            return "The URL for the API request was invalid"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode APi response: \(error.localizedDescription)"
        case .apiError(let message):
            return "APi error: \(message)"
        }
    }
}
