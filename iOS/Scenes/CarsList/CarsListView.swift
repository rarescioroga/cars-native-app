//
//  CarsListView.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import SwiftUI

struct CarsListView: View {
    
    @ObservedObject var viewModel: CarsListViewModel = CarsListViewModel()
    @State private var showCarDetails = false
    @State private var selectedCar: Car?
    @State private var didShakeDevice: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.carList.isEmpty {
                    Text("No Cars added")
                } else {
                    ScrollView {
                        ForEach(viewModel.carList, id: \.id) { car in
                            CarItemView(car: car)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    self.selectedCar = car
                                    self.showCarDetails = true
                                }
                        }
                    }
                }
                
                NavigationLink(destination: CarDetailView(viewModel: CarDetailViewModel(car: selectedCar), onBack: {
                    self.showCarDetails = false
                    self.viewModel.getAllCars()
                }),
                               isActive: $showCarDetails,
                               label: { EmptyView() } )
            }
            .navigationBarHidden(false)
            .navigationBarTitle("Cars", displayMode: .automatic)
            .navigationBarItems(leading: Button(action: {
                self.selectedCar = nil
                self.showCarDetails = true
            }, label: {
                Text("Add Car")
                    .foregroundColor(.green)
            }),
                                trailing: Button(action: {
                UserDefaults.standard.setToken(nil)
                UserDefaults.standard.setUser(nil)
                self.showLogin()
            }, label: {
                Text("Logout")
                    .foregroundColor(.red)
            }))
        }
        .onAppear {
            viewModel.getAllCars()
        }
        .onShake {
            self.didShakeDevice = true
        }
        .alert(isPresented: $didShakeDevice) {
            Alert(title: Text("Important message"),
                  message: Text("You Shook the device"),
                  dismissButton: .default(Text("Got it!")))
        }
        .noInternetModifier()
    }
    
}

struct CarsListView_Previews: PreviewProvider {
    static var previews: some View {
        CarsListView()
    }
}

// MARK: - Navigation

extension CarsListView {
    
    func showLogin() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.loadNewRoot(rootView: AnyView(LoginView(viewModel: LoginViewModel())))
    }
    
}
