import CoreLocation
import Foundation

/// A ``Location`` is a data class for storing the coordinates of a geo
/// location, meaning the latitude and longitude.
class Location : ObservableObject, Identifiable {
    @Published var text: String = "Unknown location"
    @Published var isAllowed: Bool = false
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
}

/// A Provider for the current location. Please note, that calling the method
/// ``getCurrentLocation()`` requires the user to have permitted the app to
/// access the current location.
protocol LocationProvider {
    /// Finds the current location.
    func getCurrentLocation();
}

class LocationProviderMock : LocationProvider {
    private let location: Location
    private let delegate: UpdateDelegate
    
    init(location: Location, delegate: UpdateDelegate) {
        self.location = location
        self.delegate = delegate
    }
    
    func getCurrentLocation() {
        location.text = "Cologne"
        location.isAllowed = true
        location.latitude = 50.5633
        location.longitude = 6.5732
        
        delegate.update()
    }
}

class LocationProviderGps : NSObject, LocationProvider, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    private let location: Location
    private let delegate: UpdateDelegate
    
    init(location: Location, delegate: UpdateDelegate) {
        self.location = location
        self.delegate = delegate
    }
    
    /*
     * I don't know why this method is never executed ...
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            self.location.isAllowed = true
            
            self.location.latitude = latitude
            self.location.longitude = longitude
            
            let status = manager.authorizationStatus
            switch status {
                case .authorizedAlways:
                self.location.isAllowed = true
                break
                case .authorizedWhenInUse:
                self.location.isAllowed = true
                break
                case .denied:
                self.location.isAllowed = false
                break
                case .notDetermined:
                self.location.isAllowed = false
                break
                case .restricted:
                self.location.isAllowed = false
                break
            @unknown default:
                self.location.isAllowed = false
                break
            }
            
            print(latitude)
            print(longitude)
            
            delegate.update()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.location.isAllowed = false
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
