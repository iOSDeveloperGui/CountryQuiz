//
//  CountryServiceData.swift
//  CountryQuiz
//
//  Created by iOS Developer on 27/10/25.
//

import Foundation

protocol CountryServiceProtocol{
    func fetchCountries() async throws -> [Country]
}

class CountryServiceData: CountryServiceProtocol{
    
    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags")
        else {
            throw FlagApiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpReponse = response as? HTTPURLResponse, httpReponse.statusCode == 200 else{
            throw FlagApiError.apiError("Server responded with error")
        }
        
        do{
            return try JSONDecoder().decode([Country].self, from: data)
        } catch{
            throw FlagApiError.decodingError(error)
        }
    }
}
