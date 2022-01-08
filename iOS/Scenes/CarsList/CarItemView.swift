//
//  CarItemView.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import SwiftUI

struct CarItemView: View {
    
    @ObservedObject private var imageLoader: ImageLoader
    @State private var data: Data?
    @State var image: UIImage = UIImage()

    var car: Car
    
    init(car: Car) {
        self.car = car
        self.imageLoader = ImageLoader(urlString: car.imageUrl ?? "")
    }
    
    var body: some View {
        
        VStack {
            
            if let imageData = self.data {
                Image(uiImage: UIImage(data: imageData) ?? .checkmark)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
            }
            
            Text("Brand: \(car.brand)")
                .foregroundColor(.black)
                .font(.headline)
            
            Text("Model: \(car.model)")
                .foregroundColor(.black)
                .font(.body)
            
            Text("Nr of owners: \(car.nrOfOwners)")
                .foregroundColor(.black)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .onReceive(imageLoader.didChange, perform: { data in
            self.data = data
        })
        .frame(maxWidth: .infinity)
        .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 0.7))

    }
}
