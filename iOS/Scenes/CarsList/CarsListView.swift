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
    
    var body: some View {
        
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
            
            NavigationLink(destination: CarDetailView(viewModel: CarDetailViewModel(car: selectedCar)),
                           isActive: $showCarDetails,
                           label: { EmptyView() } )
        }
        .navigationBarTitle("Cars")
        .navigationBarItems(trailing:
                                Button(action: {
                                    UserDefaults.standard.setToken(nil)
                                    UserDefaults.standard.setUser(nil)
                                }, label: {
                                    Text("Logout")
                                        .foregroundColor(.red)
                                })
        )
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
        }, label: {
            Text("Logout")
                .foregroundColor(.red)
        }))
        .onAppear {
            viewModel.getAllCars()
        }
    }
}

struct CarsListView_Previews: PreviewProvider {
    static var previews: some View {
        CarsListView()
    }
}
