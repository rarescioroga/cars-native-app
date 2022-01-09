//
//  LoginView.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        
        VStack(spacing: 40) {
            
            Text("Cars App")
                .font(.title)
                .foregroundColor(.green)
            
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
            
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
            
            Button(action: {
                self.viewModel.login()
            }, label: {
                Text("Login")
            })
        }
        .background(Color.white)
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(viewModel.command) { (command) in
            switch command {
                case .showMainView:
                    self.showMainDashboard()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}

// MARK: - Navigation

extension LoginView {
    
    func showMainDashboard() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.loadNewRoot(rootView: AnyView(CarsListView()))
    }
}

