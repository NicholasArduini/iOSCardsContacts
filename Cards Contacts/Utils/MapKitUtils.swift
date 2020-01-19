//
//  MapKitUtils.swift
//  Cards Contacts
//
//  Created by Nicholas Arduini on 1/12/20.
//  Copyright © 2020 Nicholas Arduini. All rights reserved.
//

import MapKit

class MapKitUtils {
    
    static func launchOnMap(lat: CLLocationDegrees, lon: CLLocationDegrees, name: String) {
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
    
    static func getLatLonFrom(address: String, onError: @escaping (String) -> (), onSuccess: @escaping (CLLocationDegrees, CLLocationDegrees) -> ()) {
        
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(address,completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            
            if let error = error {
                onError(error.localizedDescription)
                return
            } else {
                if let placemarks = placemarks {
                    if (placemarks.count > 0) {
                        let topResult: CLPlacemark = placemarks[0]
                        let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                        
                        if let location = placemark.location {
                            let lat = location.coordinate.latitude
                            let lon = location.coordinate.longitude
                            onSuccess(lat, lon)
                            return
                        }
                    }
                }
            }
            
            onError("Could not find lat lon for provided address")
        })
    }
    
    static func generateMapImageFrom(lat: CLLocationDegrees, lon: CLLocationDegrees, bounds: CGRect, onError: @escaping (String) -> (), onSuccess: @escaping (UIImage) -> ()) {
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        
        let location = CLLocationCoordinate2DMake( lat, lon)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 600, longitudinalMeters: 600)
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: bounds.width, height: bounds.height)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot:MKMapSnapshotter.Snapshot?, error:Error?) in
            
            if let error = error {
                onError(error.localizedDescription)
                return
            } else if let snapshot = snapshot {
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: CGPoint.zero)

                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocation(latitude: lat, longitude: lon).coordinate
                
                let point: CGPoint = snapshot.point(for: annotation.coordinate)
                self.drawPin(point: point, annotation: annotation)
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                if let compositeImage = compositeImage {
                    onSuccess(compositeImage)
                    return
                }
            }
            
            onError("Image could not be generated")
        }
    }
    
    private static func drawPin(point: CGPoint, annotation: MKAnnotation) {
        let PIN_IDENTIFIER = "UI_IMAGE_PIN"
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: PIN_IDENTIFIER)
        annotationView.contentMode = .scaleAspectFit
        annotationView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        annotationView.drawHierarchy(in: CGRect(
            x: point.x - annotationView.bounds.size.width / 2.0,
            y: point.y - annotationView.bounds.size.height,
            width: annotationView.bounds.width,
            height: annotationView.bounds.height),
                                     afterScreenUpdates: true)
    }
}
