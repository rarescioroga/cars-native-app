//
//  CarDetailView.swift
//  Cars
//
//  Created by user on 04.01.2022.
//

import SwiftUI
import MapKit

struct CarDetailView: View {
    
    @ObservedObject var viewModel: CarDetailViewModel
    @State private var imagePickerType: UIImagePickerController.SourceType = .camera
    
    @State var showImagePicker: Bool = false
    @State var showActionSheet: Bool = false
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417), latitudinalMeters: 1, longitudinalMeters: 1)
    @State var tracking : MapUserTrackingMode = .follow
    @State var manager = CLLocationManager()
    @StateObject var managerDelegate = LocationDelegate()
    
    init(viewModel: CarDetailViewModel) {
        self.viewModel = viewModel
        self.imageLoader = ImageLoader(urlString: viewModel.car?.imageUrl ?? "")
    }
    
    @ObservedObject private var imageLoader: ImageLoader
    @State private var data: Data?
    @State var image: UIImage = UIImage()
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
                if let imageData = self.data {
                    Image(uiImage: UIImage(data: imageData) ?? .checkmark)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                } else if let newImageData = self.viewModel.imageData {
                    Image(uiImage: UIImage(data: newImageData) ?? .checkmark)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .cornerRadius(8)
                } else {
                    Button {
                        self.showActionSheet = true
                    } label: {
                        Text("Add Image")
                            .font(.headline)
                        
                    }
                    
                }
                
                TextField("Brand", text: $viewModel.brand)
                    .foregroundColor(.black)
                    .padding(.top, 24 )
                
                TextField("Model", text: $viewModel.model)
                    .foregroundColor(.black)
                
                TextField("Number of Owners", text: $viewModel.nrOwners)
                    .keyboardType(.numberPad)
                    .foregroundColor(.black)
                
                DatePicker("Registration date", selection: $viewModel.date,
                           displayedComponents: .date)
                
                Toggle(isOn: $viewModel.isRepainted) {
                    Text("Repainted")
                }
                .padding(.trailing, 4)
                
                Map(coordinateRegion: $region,
                    interactionModes: .all,
                    showsUserLocation: true, userTrackingMode: $tracking,
                    annotationItems: managerDelegate.pins) { pin in
                    MapPin(coordinate: pin.location.coordinate, tint: .red)
                    
                }
                .frame(width: 400, height: 300)
                
                
                //                Map(coordinateRegion: $region, showsUserLocation: true,
                //                    userTrackingMode: .constant(.follow),
                //                    annotationItems: [AnnotatedItem(name: "Times Square", coordinate: .init(latitude: self.userLatitude, longitude:  self.userLongitude))]) { item in
                //                    MapMarker(coordinate: item.coordinate, tint: .red)
                //                }
                
                Spacer()
                
                Button {
                    self.viewModel.performAction()
                } label: {
                    Text(viewModel.buttonTitle)
                        .font(.headline)
                }
                
                
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .onReceive(imageLoader.didChange, perform: { data in
            self.data = data
        })
        .onAppear{
            manager.delegate = managerDelegate
        }
        .navigationBarTitle("Car details".uppercased())
        .actionSheet(isPresented: $showActionSheet, content: { () -> ActionSheet in
            ActionSheet(title: Text("Upload an attachment"),
                        message: Text("Please select an image source"), buttons: [
                            .default(Text("Library")) {
                                self.imagePickerType = .photoLibrary
                                self.showImagePicker = true
                            },
                            .default(Text("Camera")) {
                                self.imagePickerType = .camera
                                self.showImagePicker = true
                            },
                            .cancel()])
        })
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: self.imagePickerType) { image in
                self.viewModel.sendImage(imageData: image.jpegData(compressionQuality: 0.7))
            }
        }
    }
}

class LocationDelegate: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var pins : [Pin] = []
    
    // Checking authorization status...
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedWhenInUse{
            print("Authorized")
            manager.startUpdatingLocation()
        } else {
            print("not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        pins.append(Pin(location:locations.last!))
    }
}

// Map pins for update
struct Pin : Identifiable {
    var id = UUID().uuidString
    var location : CLLocation
}
