//
//  LocationManager.swift
//  BaseProject
//
//  Created by MTQ on 10/9/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation
import INTULocationManager

typealias LMReverseGeocodeCompletionHandler = ((_ reverseGecodeInfo:NSDictionary?,_ placemark:CLPlacemark?, _ error:String?)->Void)

class LocationManager {
    private var locationRequestID: INTULocationRequestID = 0
    private var desiredAccuracy: INTULocationAccuracy = .city
    private var timeout: TimeInterval = 8.0
    
    static let shared = LocationManager()
    private init() {
        
    }
    
    /**
     Starts a new one-time request for the current location.
     */
    func startSingleLocationRequest() {
        let locMgr = INTULocationManager.sharedInstance()
        self.locationRequestID = locMgr.requestLocation(withDesiredAccuracy: self.desiredAccuracy, timeout: self.timeout, block: { [weak self] (currentLocation, achievedAccuracy, status) in
            if status == INTULocationStatus.success {
                print("Location request successful! Current Location:\n\(currentLocation)")
            } else if status == INTULocationStatus.timedOut {
                print("Location request timed out. Current Location:\n")
            } else {
                print(self?.getLocationErrorDescription(status: status))
            }
        })
    }
    
    /**
     Starts a new subscription for location updates.
     */
    func startLocationUpdateSubscription() {
        let locMgr = INTULocationManager.sharedInstance()
        // Nếu ko cần độ chính xác cao nhất thì gọi subscribeToLocationUpdatesWithBlock
        // Ưu điểm là tiết kiệm pin
        self.locationRequestID = locMgr.subscribeToLocationUpdates(withDesiredAccuracy: self.desiredAccuracy, block: { [weak self] (currentLocation, achievedAccuracy, status) in
            if status == INTULocationStatus.success {
                print("'Location updates' subscription block called with Current Location:\n\(currentLocation)")
            } else {
                print(self?.getLocationErrorDescription(status: status))
            }
        })
    }
    
    /**
     Starts a new subscription for significant location changes.
     */
    func startMonitoringSignificantLocationChanges() {
        let locMgr = INTULocationManager.sharedInstance()
        self.locationRequestID = locMgr.subscribeToSignificantLocationChanges({ [weak self] (currentLocation, achievedAccuracy, status) in
            if status == INTULocationStatus.success {
                print("'Significant changes' subscription block called with Current Location:\n\(currentLocation)")
            } else {
                print(self?.getLocationErrorDescription(status: status))
            }
        })
    }
    
    func getLocationErrorDescription(status: INTULocationStatus) -> String {
        if status == INTULocationStatus.servicesNotDetermined {
            return "Error: User has not responded to the permissions alert."
        } else if status == INTULocationStatus.servicesDenied {
            return "Error: User has denied this app permissions to access device location."
        } else if status == INTULocationStatus.servicesRestricted {
            return "Error: User is restricted from using location services by a usage policy."
        } else if status == INTULocationStatus.servicesDisabled {
            return "Error: Location services are turned off for all apps on this device."
        }
        return "An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)"
    }
    
    fileprivate var reverseGeocodingCompletionHandler:LMReverseGeocodeCompletionHandler?
    
    func reverseGeocodeLocationWithLatLon(latitude:Double, longitude: Double,onReverseGeocodingCompletionHandler:@escaping LMReverseGeocodeCompletionHandler) {
        let location:CLLocation = CLLocation(latitude:latitude, longitude: longitude)
        reverseGeocodeLocationWithCoordinates(location,onReverseGeocodingCompletionHandler: onReverseGeocodingCompletionHandler)
    }
    
    func reverseGeocodeLocationWithCoordinates(_ coord:CLLocation, onReverseGeocodingCompletionHandler:@escaping LMReverseGeocodeCompletionHandler) {
        self.reverseGeocodingCompletionHandler = onReverseGeocodingCompletionHandler
        reverseGocode(coord)
    }
    
    fileprivate func reverseGocode(_ location:CLLocation) {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                self.reverseGeocodingCompletionHandler?(nil,nil, error!.localizedDescription)
            } else {
                if let placemark = placemarks?.first {
                    let address = AddressParser()
                    address.parseAppleLocationData(placemark)
                    let addressDict = address.getAddressDictionary()
                    self.reverseGeocodingCompletionHandler!(addressDict,placemark,nil)
                } else {
                    self.reverseGeocodingCompletionHandler!(nil,nil,"No Placemarks Found!")
                    return
                }
            }
        })
    }
}

class AddressParser: NSObject {
    
    var latitude = ""
    var longitude  = ""
    var streetNumber = ""
    var route = ""
    var locality = ""
    var subLocality = ""
    var formattedAddress = ""
    var administrativeArea = ""
    var administrativeAreaCode = ""
    var subAdministrativeArea = ""
    var postalCode = ""
    var country = ""
    var subThoroughfare = ""
    var thoroughfare = ""
    var ISOcountryCode = ""
    var state = ""
    
    fileprivate func parseAppleLocationData(_ placemark:CLPlacemark) {
        let addressLines = placemark.addressDictionary!["FormattedAddressLines"] as! NSArray
        //self.streetNumber = placemark.subThoroughfare ? placemark.subThoroughfare : ""
        self.streetNumber = placemark.thoroughfare ?? ""
        self.locality = placemark.locality ?? ""
        self.postalCode = placemark.postalCode ?? ""
        self.subLocality = placemark.subLocality ?? ""
        self.administrativeArea = placemark.administrativeArea ?? ""
        self.country = placemark.country ?? ""
        self.longitude = placemark.location?.coordinate.longitude.description ?? ""
        self.latitude = placemark.location?.coordinate.latitude.description ?? ""
        if(addressLines.count>0){
            self.formattedAddress = addressLines.componentsJoined(by: ", ")
        }
        else{
            self.formattedAddress = ""
        }
    }
    
    fileprivate func getAddressDictionary()-> NSDictionary {
        let addressDict = NSMutableDictionary()
        addressDict.setValue(latitude, forKey: "latitude")
        addressDict.setValue(longitude, forKey: "longitude")
        addressDict.setValue(streetNumber, forKey: "streetNumber")
        addressDict.setValue(locality, forKey: "locality")
        addressDict.setValue(subLocality, forKey: "subLocality")
        addressDict.setValue(administrativeArea, forKey: "administrativeArea")
        addressDict.setValue(postalCode, forKey: "postalCode")
        addressDict.setValue(country, forKey: "country")
        addressDict.setValue(formattedAddress, forKey: "formattedAddress")
        return addressDict
    }
}
