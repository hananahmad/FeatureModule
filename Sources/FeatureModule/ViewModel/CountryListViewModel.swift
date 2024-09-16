//
//  File.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import Foundation
import Combine
import NetworkingLayer

import Foundation
import Combine

final class CountryListViewModel {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let countryListUseCase: CountryListUseCaseProtocol
    private var statusSubject = PassthroughSubject<Output, Never>()
    
    var statusPublisher: AnyPublisher<Output, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(countryListUseCase: CountryListUseCaseProtocol) {
        self.countryListUseCase = countryListUseCase
    }
    
    // MARK: - Methods
    
    func getCountryList() {
        countryListUseCase.getCountryList()
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .didSucceed(let response):
                    debugPrint(response.countryList?.map({$0.countryName ?? ""}) ?? response)
                    self.statusSubject.send(.fetchCountriesDidSucceed(response: response))

                case .didFail(let errorString):
                    self.statusSubject.send(.fetchCountriesDidFail(error: errorString))
                }
                
            }
            .store(in: &cancellables)
    }
}

