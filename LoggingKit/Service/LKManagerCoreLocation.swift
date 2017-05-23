//
//  LKManagerCoreLocation.swift
//  LoggingKit
//
//  Created by Andreatta Massimiliano on 23/05/17.
//  Copyright © 2017 Exage S.p.A. All rights reserved.
//

import Foundation

import CoreLocation
import RxSwift

extension CLLocationCoordinate2D
{

}

public class LKManagerCoreLocation:NSObject {
    
    static let sharedInstance = LKManagerCoreLocation()
    
    var locationManager = CLLocationManager()
    
    var coordinate: Variable<CLLocationCoordinate2D?> = Variable<CLLocationCoordinate2D?>(nil)
    
    let disposeBag = DisposeBag()

    override init()
    {
        super.init()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
    }
    
    public func getCurrentLocation(complete:@escaping (CLLocationCoordinate2D?) -> Void)
    {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
            
            self.coordinate.asObservable().skip(10).subscribe(onNext: { (coordinate) in
                
                complete(coordinate)
                
            }, onError: { (error) in
                
                complete(nil)
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).addDisposableTo(self.disposeBag)
        }
    }
    
}

extension LKManagerCoreLocation: CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        self.coordinate.value = manager.location!.coordinate
        
        self.locationManager.stopUpdatingLocation()
    }
}
