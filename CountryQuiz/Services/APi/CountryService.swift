//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation
import SwiftUI

class CountryService{
    //MARK: - Property
    private let countryServiceData: CountryServiceProtocol
    
    //MARK: - Initialization
    init(countryServiceData: CountryServiceProtocol){
        self.countryServiceData = countryServiceData
    }
    
    //MARK: - FetchCountries
    public func fetchCountries() async throws -> [Country]{
        return try await countryServiceData.fetchCountries()
    }
}
