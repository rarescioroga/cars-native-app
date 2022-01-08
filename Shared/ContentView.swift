//
//  ContentView.swift
//  Shared
//
//  Created by user on 05.12.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            
            VStack {
                if UserDefaults.standard.user != nil {
                    CarsListView()
                } else {
                    LoginView(viewModel: LoginViewModel())
                }
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
