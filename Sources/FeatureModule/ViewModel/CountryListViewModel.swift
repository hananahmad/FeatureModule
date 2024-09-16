//
//  File.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import Foundation
import Combine
import NetworkingLayer

class CountryListViewModel: NSObject {
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var baseURL: String
    
    // MARK: - Init
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
}


extension CountryListViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getCountriesList:
                self?.getCountries(baseURL: self?.baseURL ?? "")
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    
    func getCountries(baseURL: String) {
       //self.output.send(.showLoader(shouldShow: true))
        let request = CountryListRequest()
        request.firstCallFlag = true
        request.lastModifiedDate = ""
        
        let service = LoginWithOtpRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseURL: baseURL,
            endPoint: .getCountries
        )
        
        service.getAllCountriesService(request: request)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    //self?.output.send(.showLoader(shouldShow: false))
                    self?.output.send(.fetchCountriesDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                //self?.output.send(.showLoader(shouldShow: false))
                if response.countryList?.count ?? 0 > 0 {
                    self?.output.send(.fetchCountriesDidSucceed(response: response))
                    CountryListResponse.saveCountryListResponse(countries: response)
                } else {
                    if CountryListResponse.isCountriesListAvailableInCache() {
                        if let res = CountryListResponse.getCountryListResponse(), let list = res.countryList, list.count > 0 {
                            self?.output.send(.fetchCountriesDidSucceed(response: res))
                        }
                    } else {
                        self?.output.send(.fetchCountriesDidFail(error: NetworkError.apiError(code: 0, error: (response.responseMsg ?? response.errorMsg) ?? "Error")))
                    }
                }
            }
        .store(in: &cancellables)
    }
}
