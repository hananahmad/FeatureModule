//
//  File.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import UIKit
import NetworkingLayer

public protocol CountryListConfiguratorProtocol {
    func setUpCountryListModule() -> UIViewController
}

public struct CountryListConfigurator: CountryListConfiguratorProtocol {
    
    public init() {}
    
    public func setUpCountryListModule() -> UIViewController {
        let countryListUseCase = CountryListUseCase(repository: repository)
        let viewModel = CountryListViewModel(countryListUseCase: countryListUseCase)
        
        return CountryListViewController(viewModel: viewModel)
    }
    
    var network: Requestable {
        NetworkingLayerRequestable(requestTimeOut: 60)
    }
    
    var repository: CountryListServiceable {
        CountryListRepository(networkRequest: network)
    }
}
