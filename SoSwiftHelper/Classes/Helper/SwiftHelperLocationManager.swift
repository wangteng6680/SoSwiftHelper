//
//  SwiftHelperLocationManager.swift
//  Pods-SoSwiftHelper_Example
//
//  Created by mac on 2020/7/5.
//

import UIKit
import CoreLocation

public class SwiftHelperLocationManager: NSObject {
    
    @objc
    public enum LocationUpdateProxy: Int {
        case once
        case always
        case none
    }
    
    /// 用户授权状态发生改变
    @objc
    public var didChangeAuthorization: ((CLAuthorizationStatus) -> Void)?
    
    /// 位置变更
    @objc
    public var didUpdateLocations: (([CLLocation]) -> Void)?
    
    /// 当前位置授权状态
    public var currentAuthorizationStatus: CLAuthorizationStatus?
    
    @objc
    static public let shared = SwiftHelperLocationManager()
    
    @objc
    public var updateProxy: LocationUpdateProxy = .none
    
    @objc
    public var locationManager: CLLocationManager = {
        return CLLocationManager()
    }()
    
    override public init() {
        super.init()
    }
    
    @objc
    public func start(_ updateProxy: LocationUpdateProxy) {
        self.updateProxy = updateProxy
        if updateProxy == .none {
            locationManager.delegate = nil
            stopUpdatingLocation()
            return
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        startUpdatingLocation()
    }
    
    /// 开始更新位置
    @objc
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// 停止更新位置
    @objc
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// 是否开启定位服务
    @objc
    public class var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// 位置授权状态
    /// - Returns: `true` or `false`
    @objc
    @discardableResult
    public class func authorization() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            return false
        case .restricted:
            return false
        case .denied:
            return false
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }
    
    @objc
    public func didChangeAuthorization(_ block: @escaping(CLAuthorizationStatus) -> Void) {
        self.didChangeAuthorization = block
    }
    
    @objc
    public func didUpdateLocations(_ block: @escaping([CLLocation]) -> Void) {
        self.didUpdateLocations = block
    }
}

extension SwiftHelperLocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        
        currentAuthorizationStatus = status
        didChangeAuthorization?(status)
        
        if status == .restricted || status == .denied {
            stopUpdatingLocation()
        } else {
            start(self.updateProxy)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        switch updateProxy {
        case .always:
            didUpdateLocations?(locations)
        case .once:
            locationManager.delegate = nil
            stopUpdatingLocation()
            didUpdateLocations?(locations)
        case .none:
            break
        }
    }
}
