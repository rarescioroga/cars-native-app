//
//  LoginViewModel.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var alertMessage: String = ""
    @Published var showsAlert: Bool = false

    
    private var repository: LoginRepository

    // MARK: - Lifecycle
    init(repository: LoginRepository = LoginRepositoryImpl()) {
        self.repository = repository
    }
    
    func login() {
        self.repository.login(username: self.username,
                              password: self.password) { result  in
            switch result {
            case .failure(let error):
                self.alertMessage = error.message
                self.showsAlert = true
                
            case .success:
                print("success")
            }
        }
    }
    
}
