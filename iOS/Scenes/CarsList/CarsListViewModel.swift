//
//  CarsListViewModel.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

class CarsListViewModel: ObservableObject {
    
    @Published var carList: [Car] = []
    
    @Published var alertMessage: String = ""
    @Published var showsAlert: Bool = false
    
    private var repository: CarsListRepository

    // MARK: - Lifecycle
    init(repository: CarsListRepository = CarsListRepositoryImpl()) {
        self.repository = repository
        self.updateWithLocalData()
    }
    
    func getAllCars() {
        
        self.repository.getCars { result in
            switch result {
            case .failure(let error):
                self.alertMessage = error.message
                self.showsAlert = true

            case .success(let response):
                UserDefaults.standard.setCars(response)
                self.carList = response
            }
        }
    }
    
    func updateWithLocalData() {
        self.repository.updateCars { result in
            switch result {
            case .failure(let error):
                self.alertMessage = error.message
                self.showsAlert = true

            case .success(let response):
                print("succcess")
            }
        }
    }
}
