//
//  File.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import Foundation
import NetworkingLayer

extension CountryListViewModel {
    enum Input {
        case getCountriesList
    }
    
    enum Output {
        case fetchCountriesDidSucceed(response: CountryListResponse)
        case fetchCountriesDidFail(error: String)
    }
}
