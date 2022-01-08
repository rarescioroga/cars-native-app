//
//  CarDetailViewModel.swift
//  Cars
//
//  Created by user on 04.01.2022.
//

import Foundation

class CarDetailViewModel: ObservableObject, ImageSavingProtocol {
    
    @Published var car: Car?
    
    @Published var alertMessage: String = ""
    @Published var showsAlert: Bool = false
    
    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var date: Date = Date()
    @Published var nrOwners: String = ""
    @Published var isRepainted: Bool = false
    
    @Published var imageData: Data?

    
//    @Published var coordinates: Coordinates =
    @Published var buttonTitle: String = ""

    private var repository: CarDetailRepository

    // MARK: - Lifecycle
    init(car: Car? = nil, repository: CarDetailRepository = CarDetailRepositoryImpl()) {
        self.repository = repository
        self.car = car
        self.addCarData()
    }
    
    func addCarData() {
        if let car = self.car {
            self.brand = car.brand
            self.model = car.model
            self.nrOwners = String(car.nrOfOwners)
            self.date = Date()
            self.isRepainted = car.isRepainted ?? false
            self.buttonTitle = "Update"
        } else {
            self.buttonTitle = "Create"
        }
    }
    
    func performAction() {
        if self.car == nil {
            self.createCar()
        } else {
            self.updateCar()
        }
    }
   
    func updateCar() {
        guard let existingCarId = self.car?.id, let newCar = self.car else {
            return
        }
        
        self.repository.updateCar(car: newCar, data: self.imageData ?? nil) { result in
            switch result {
            case .failure(let error):
                self.alertMessage = error.message
                self.showsAlert = true
                
            case .success(let response):
                self.car = response
            }
        }
    }
    
    func createCar() {
        let car = Car(id: nil,
                      brand: self.brand,
                      model: self.model,
                      firstRegisterDate: self.date,
                      nrOfOwners: Int(self.nrOwners) ?? 0,
                      isRepainted: self.isRepainted,
                      imageUrl: nil,
                      userId: nil,
                      coordinates: nil)
        
        self.repository.createCar(car: car, data: self.imageData ?? nil) { result in
            switch result {
            case .failure(let error):
                self.alertMessage = error.message
                self.showsAlert = true
                
            case .success(let response):
                self.car = response
            }
        }
    }
    
    // Send Image
    
    func sendImage(imageData: Data?) {
        guard let data = imageData else {
            return
        }
        let fileName = "car_img.jpg"

        do {
            _ = try self.save(imageData: data, withName: fileName)
            self.imageData = data
        } catch let error  {
            print(error)
        }

    }
}

