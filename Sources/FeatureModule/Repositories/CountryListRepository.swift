//
//  File.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesBaseMainRequestManager

protocol CountryListServiceable {
    func getAllCountriesService(request: CountryListRequest) -> AnyPublisher<CountryListResponse, NetworkError>
}

// CountryListRepository
class CountryListRepository: CountryListServiceable {
    
    private var networkRequest: Requestable

  // inject this for testability
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
  
    func getAllCountriesService(request: CountryListRequest) -> AnyPublisher<CountryListResponse, NetworkError> {
        
        let endPoint = CountryListRequestBuilder.getCountries(request: request)
        let request = endPoint.createRequest(baseURL: "YOUR_BASE_URL", endPoint: .getCountries)
        
        let countries: CountryListResponse = loadMockData(filename: "Country", as: CountryListResponse.self) ?? CountryListResponse()
        return Just(countries)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        
            // I am commenting this and datasource for now will be fetched from local json please dont call the actual api but i am giving example to how you will get actual response from network layer just change endpoint to your dummy one and test if required.
        
//        return self.networkRequest.request(request)
    }
    
    
    //MARK: - Load Mock JSON
    func loadMockData<T: Codable>(filename: String, as type: T.Type) -> T? {
        // 1. Locate the JSON file in the bundle
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else {
            print("File \(filename) not found.")
            return nil
        }
        
        // 2. Load the data from the file
        do {
            let data = try Data(contentsOf: url)
            
            // 3. Decode the data into the Codable object
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            print("Error decoding \(filename): \(error)")
            return nil
        }
    }
    
}

