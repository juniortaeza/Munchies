//
//  MapViewController.swift
//  munchies
//
//  Created by junior taeza on 12/5/22.
//

import UIKit
import MapKit

class pin : NSObject, MKAnnotation {
    var title : String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, location: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = location
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        self.mapView.layer.borderColor = UIColor.black.cgColor
        self.mapView.layer.borderWidth = 0.75
        self.mapView.layer.cornerRadius = 5.0
        
        let sL = CLLocationCoordinate2D(latitude: User.user.latitude, longitude: User.user.longitude)
        let dL = CLLocationCoordinate2D(latitude: CurrentRestaurant.cr.lat, longitude: CurrentRestaurant.cr.lon)
        
        let sPin = pin(title: "You", location: sL)
        let dPin = pin(title: CurrentRestaurant.cr.name, location: dL)
        self.mapView.addAnnotation(sPin)
        self.mapView.addAnnotation(dPin)
        
        getDirections()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .orange
        renderer.lineWidth = 3.5
        return renderer
    }
    
    // obtains the route from user's current location to restaurant
    func getDirections() { 
        // PlaceMarks
        let sourcePM = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: User.user.latitude, longitude: User.user.longitude))
        
        let destinationPM = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CurrentRestaurant.cr.lat, longitude: CurrentRestaurant.cr.lon))
        
        // MapItems
        let sourceMI = MKMapItem(placemark: sourcePM)
        let destinationMI = MKMapItem(placemark: destinationPM)
        
        // get directions
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMI
        directionsRequest.destination = destinationMI
        directionsRequest.transportType = [.walking, .automobile]
        directionsRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
}
