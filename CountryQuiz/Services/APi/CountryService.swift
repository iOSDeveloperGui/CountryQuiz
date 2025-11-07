//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation
import SwiftUI

class CountryService{
    private let countryServiceData: CountryServiceProtocol
    
    init(countryServiceData: CountryServiceProtocol){
        self.countryServiceData = countryServiceData
    }
    
    public func fetchCountries() async throws -> [Country]{
        return try await countryServiceData.fetchCountries()
    }
}
