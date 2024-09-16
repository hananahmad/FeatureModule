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


protocol CountryListUseCaseProtocol {
    func getCountryList() -> AnyPublisher<CountryListUseCase.State, Never>
}

final class CountryListUseCase: CountryListUseCaseProtocol {
    // MARK: - Properties
    private let repository: CountryListServiceable
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(repository: CountryListServiceable) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getCountryList() -> AnyPublisher<State, Never> {
        let request = CountryListRequest()
        
        return Future<State, Never> { [weak self] promise in
            guard let self else { return }
            
            self.repository.getAllCountriesService(request: request)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.didFail(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    promise(.success(.didSucceed(response: response)))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

extension CountryListUseCase {
    enum State {
        case didFail(message: String)
        case didSucceed(response: CountryListResponse)
    }
}
