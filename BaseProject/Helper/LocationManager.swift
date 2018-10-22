//
//  LocationManager.swift
//  BaseProject
//
//  Created by MTQ on 10/9/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation
import INTULocationManager

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
}
