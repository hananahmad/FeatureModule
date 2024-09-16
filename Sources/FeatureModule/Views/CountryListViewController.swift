//
//  CountryListViewController.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import UIKit
import Combine

class CountryListViewController: UIViewController {
    
    //MARK: - Properties
    
    var input: PassthroughSubject<CountryListViewModel.Input, Never> = .init()
    private var viewModel: CountryListViewModel!
    private var baseURL: String = ""
    private var cancellables = Set<AnyCancellable>()
    private var countriesList: CountryListResponse?
    
    public init?(coder: NSCoder, baseURL: String) {
        super.init(coder: coder)
        self.baseURL = baseURL
        viewModel = CountryListViewModel(baseURL: baseURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        getCountiresFromWebService()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Binding
    
    func bind(to viewModel: CountryListViewModel) {
        input = PassthroughSubject<CountryListViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchCountriesDidSucceed(response: let response):
                    self?.countriesList = response
                    break
                case .fetchCountriesDidFail(error: let error):
                    break

                }
            }.store(in: &cancellables)
    }


    //MARK: - Functions
    //Get Country list
    func getCountiresFromWebService() {
     
        self.input.send(.getCountriesList)
    }

}
