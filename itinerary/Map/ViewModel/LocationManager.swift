//
//  LocationManager.swift
//  itinerary
//
//  Created by yuchenbo on 24/6/23.
//

import SwiftUI
import CoreLocation
import MapKit


import Combine


class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
    
    //userlocation
    @Published var userLocation: CLLocation?
    
    //place after pin
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    
    override init() {
        
        super.init()
        
        
        manager.delegate = self
        mapView.delegate = self
        
        
        manager.requestWhenInUseAuthorization()
        
        //combine search text
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                
                if value != "" {
                    
                    self.fetchPlaces(value: value)
                } else {
                    
                    self.fetchedPlaces = nil
                }
                
            })
    }
    
    func fetchPlaces(value: String) {
        
        //MKLocalSearch & Asyc/Await
        Task {
            
            do {
                
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                await MainActor.run(body: {
                    
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        
                        return item.placemark
                    })
                })
                
            }
            catch {
                
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else { return }
        self.userLocation = currentLocation
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
            
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func handleLocationError() {
        
    }
    
    func addDraggablePin(coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Here"
        
        mapView.addAnnotation(annotation)

    }
    
    //move pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERYRPIN")
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        guard let newLocation = view.annotation?.coordinate else {return}
        
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlacemark(location: CLLocation) {
        
        Task {
            
            do {
                
                guard let place = try await reverseLocationCoordinates(location: location) else {return}
                await MainActor.run(body: {
                    
                    print("+++++")
                    self.pickedPlaceMark = place
                })
            }
            catch let Error {
                
                print(Error.localizedDescription)
                print("-----")
            }
            
            
            
        }
    }
    
    //show location
    func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
        
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        print("+++++" + (place?.name ?? "------"))
        return place
    }
    
}
