//
//  CountryListViewController.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import UIKit
import Combine

class CountryListViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: CountryListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: CountryListViewController.className, bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.getCountryList()
    }
    
    // MARK: - Actions
    
    // MARK: - Methods
    
    private func bindViewModel() {
        viewModel.statusPublisher.sink { [weak self] state in
            guard let self else { return }
            switch state {
                
            case .fetchCountriesDidSucceed(response: let response):
//                configureDataSource()
                debugPrint(response)
                
            case .fetchCountriesDidFail(error: let error):
                debugPrint(error.localizedString)

            }
        }
        .store(in: &cancellables)
    }
}
