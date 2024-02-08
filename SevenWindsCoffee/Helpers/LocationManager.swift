//
//  LocationManager.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var locationUpdateCompletion: ((Bool) -> Void)?

    private override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation(completion: @escaping (Bool) -> Void) {
        locationUpdateCompletion = completion
        locationManager?.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        } else {
            locationUpdateCompletion?(false)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        currentLocation = newLocation
        locationUpdateCompletion?(true)
    }

    func calculateDistanceToPoint(point: Point) -> Double? {
        let destinationPoint = CLLocationCoordinate2D(latitude: Double(point.latitude) ?? 0, longitude: Double(point.longitude) ?? 0)
        guard let currentLocation = currentLocation else {
            print("Location not available.")
            return nil
        }

        let destinationLocation = CLLocation(latitude: destinationPoint.latitude, longitude: destinationPoint.longitude)
        let distanceInMeters = currentLocation.distance(from: destinationLocation)
        let distanceInKilometers = distanceInMeters / 1000.0

        return distanceInKilometers
    }
    
    func requestWhenInUseAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysAuthorization() {
        locationManager?.requestAlwaysAuthorization()
    }
}

extension Notification.Name {
    static let locationAuthorizationChanged = Notification.Name("LocationAuthorizationChanged")
}
