//
//  SearchView.swift
//  itinerary
//
//  Created by yuchenbo on 24/6/23.



import SwiftUI
import MapKit

struct SearchView: View {

    @StateObject var locationManager: LocationManager = .init()

    //navigationTag jump to mapview
    @State var navigationTag: String?
    @State private var isNavigationActive = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {

        NavigationView {
            VStack {

                HStack( spacing: 15) {

                    Button{
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }
                    
                    Text("Search Location")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 10) {

                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Find locations here", text: $locationManager.searchText)
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background{

                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.gray)
                }
                .padding(.vertical, 10)


                if let places = locationManager.fetchedPlaces, !places.isEmpty {

                    List {

                        ForEach(places, id: \.self) { place in

                            Button {

                                if let coordinate = place.location?.coordinate {

                                    locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

                                    locationManager.addDraggablePin(coordinate: coordinate)
                                    locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                }

        
                                navigationTag = "MAPVIEW"

                            } label: {

                                HStack(spacing:15) {

                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)

                                    VStack(alignment: .leading, spacing: 6) {

                                        Text(place.name ?? "")
                                            .font(.title3.bold())
                                            .foregroundColor(.primary)

                                        Text(place.locality ?? "")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }

                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
//            .background {
//
//                NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
//
//                    MapViewSelection(navigationTag: $navigationTag)
//                        .environmentObject(locationManager)
//                        .navigationBarHidden(true)
//                } label: {
//
//                }
//                .labelsHidden()
//
//
//            }
            .background {
                            NavigationLink(
                                destination: MapViewSelection(navigationTag: $navigationTag)
                                    .environmentObject(locationManager),
                                tag: "MAPVIEW",
                                selection: $navigationTag
                            ) {
                                EmptyView()
                            }
                            .isDetailLink(false)
                        }
                        .onChange(of: isNavigationActive) { newValue in
                            if !newValue {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
            
        }

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MapRootView()
        }
    }
}


//MARK: MapView Live Selection
struct MapViewSelection: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    	

    @Environment(\.dismiss) var dismiss

    @Binding var navigationTag: String?

    var body: some View {

        NavigationView {
            ZStack {

                MapViewHelper()
                    .environmentObject(locationManager)
                    .ignoresSafeArea()

                Button {

                    dismiss()
                } label: {

                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                        .frame(width: 50, height: 50)
                        .background {
                            Color.red
                        }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)


                //pin
                if let place = locationManager.pickedPlaceMark {

                    VStack(spacing: 15) {

                        Text("Confirm Location")
                            .font(.title2.bold())

                        HStack(spacing:15) {

                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)

                            VStack(alignment: .leading, spacing: 6) {

                                Text(place.name ?? "")
                                    .font(.title3.bold())

                                Text(place.locality ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)


                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Confirm Location")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background{

                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.green)
                                }
                                .overlay(alignment: .trailing){

                                    Image(systemName: "arrow.right")
                                        .font(.title3.bold())
                                        .padding(.trailing)
                                }
                                .foregroundColor(.white)
                        }

                            
//                        Button {
//                            navigationTag = "TEMPVIEW"
//                        } label: {
//
//                            Text("Confirm Location")
//                                .fontWeight(.semibold)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
//                                .background{
//
//                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                                        .fill(.green)
//                                }
//                                .overlay(alignment: .trailing){
//
//                                    Image(systemName: "arrow.right")
//                                        .font(.title3.bold())
//                                        .padding(.trailing)
//                                }
//                                .foregroundColor(.white)
//                        }


                    }
                    .padding()
                    .background {

                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                            .ignoresSafeArea()
                    }
                    .frame(maxHeight:.infinity, alignment: .bottom)
                }


            }
            .onDisappear {

                locationManager.pickedLocation = nil
                locationManager.pickedPlaceMark = nil

                locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
                navigationTag = nil
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    }
}

struct MapViewHelper: UIViewRepresentable {

    @EnvironmentObject var locationManager: LocationManager

    func makeUIView(context: Context) -> MKMapView {

        return locationManager.mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {


    }
}

