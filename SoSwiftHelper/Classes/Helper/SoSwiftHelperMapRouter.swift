//
//  NIOMateMapNavigationManager.swift
//  Socket
//
//  Created by Teng Wang 王腾 on 2019/8/30.
//  Copyright © 2019 Teng Wang 王腾. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

/*
 info.plist
 
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>iosamap</string>
        <string>baidumap</string>
        <string>qqmap</string>
        <string>comgooglemaps</string>
    </array>
*/

public struct SoSwiftHelperMapRouter {

	public static func makeRouteHandlers(param: SoMapRouteHandlerParam) -> [SoMapURLRouteHandler] {

		var routeHandlers: [SoMapURLRouteHandler] = []

		/// 高德地图
		let gaodeMapRouteHandler = SoGaodeMapRouteHandler(mapRouteHandlerParam: param)
		if gaodeMapRouteHandler.canOpenURL() {
			routeHandlers.append(gaodeMapRouteHandler)
		}

		/// 百度地图
		let baiduMapRouteHandler = SoBaiduMapRouteHandler(mapRouteHandlerParam: param)
		if baiduMapRouteHandler.canOpenURL() {
			routeHandlers.append(baiduMapRouteHandler)
		}

		/// 谷歌地图
		let googleMapRouteHandler = SoGoogleMapRouteHandler(mapRouteHandlerParam: param)
		if googleMapRouteHandler.canOpenURL() {
			routeHandlers.append(googleMapRouteHandler)
		}

		/// 腾讯地图
		let tencentMapRouteHandler = SoTencentMapRouteHandler(mapRouteHandlerParam: param)
		if tencentMapRouteHandler.canOpenURL() {
			routeHandlers.append(tencentMapRouteHandler)
		}

		let appleMapHandler = SoAppleMapRouteHandler(mapRouteHandlerParam: param)
		routeHandlers.append(appleMapHandler)

		return routeHandlers
	}
}

fileprivate extension String {
	var percentEncoding: String? {
		return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
	}
}

public protocol SoMapURLRouteHandler {

	var mapRouteHandlerParam: SoMapRouteHandlerParam { get set }

	var scheme: String { get set }

	var displayName: String { get set }

	func makeURL() -> URL?

	func open(completionHandler: @escaping (Bool)->())

	func canOpenURL() ->Bool
}

public extension SoMapURLRouteHandler {

	func canOpenURL() ->Bool {
		guard let schemeURL = URL(string: scheme),
			UIApplication.shared.canOpenURL(schemeURL) else {
				return false
		}
		return true
	}

	func open(completionHandler: @escaping (Bool) -> ()) {

		/// Scheme 无效
		guard canOpenURL() else {
			completionHandler(false)
			return
		}

		/// URL 无效
		guard let url = makeURL() else {
			completionHandler(false)
			return
		}

		UIApplication.shared.open(url, options: [:]) { (result) in
			completionHandler(result)
		}
	}
}

public struct SoMapRouteHandlerParam {
	var src: CLLocationCoordinate2D?
	var srcName: String?
	var dest: CLLocationCoordinate2D?
	var destName: String?
}

public struct SoGaodeMapRouteHandler: SoMapURLRouteHandler {

	public var scheme: String = "iosamap://"

	public var displayName: String = "高德地图"

	public var mapRouteHandlerParam: SoMapRouteHandlerParam

	public func makeURL() -> URL? {
		guard let src = mapRouteHandlerParam.src,
			let srcName = mapRouteHandlerParam.srcName?.percentEncoding,
			let dest = mapRouteHandlerParam.dest,
			let destName = mapRouteHandlerParam.destName?.percentEncoding else {
				return nil
		}
		let urlString = String(format: "iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=%@&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=0",
							   src.latitude,
							   src.longitude,
							   srcName,
							   dest.latitude,
							   dest.longitude,
							   destName)
		return URL(string: urlString)
	}
}

public struct SoBaiduMapRouteHandler: SoMapURLRouteHandler {

	public var scheme: String = "baidumap://"

	public var displayName: String  = "百度地图"

	public var mapRouteHandlerParam: SoMapRouteHandlerParam

	public func makeURL() -> URL? {
		guard let src = mapRouteHandlerParam.src,
			let srcName = mapRouteHandlerParam.srcName?.percentEncoding,
			let dest = mapRouteHandlerParam.dest,
			let destName = mapRouteHandlerParam.destName?.percentEncoding else {
				return nil
		}
		let urlString = String(format: "baidumap://map/direction?origin=latlng:%f,%f|name:%@&destination=latlng:%f,%f|name:%@&mode=driving",
							   src.latitude,
							   src.longitude,
							   srcName,
							   dest.latitude,
							   dest.longitude,
							   destName)
		return URL(string: urlString)
	}
}

public struct SoTencentMapRouteHandler: SoMapURLRouteHandler {

	public var scheme: String = "qqmap://"

	public var displayName: String = "腾讯地图"

	public var mapRouteHandlerParam: SoMapRouteHandlerParam

	public func makeURL() -> URL? {
		guard let src = mapRouteHandlerParam.src,
			let srcName = mapRouteHandlerParam.srcName?.percentEncoding,
			let dest = mapRouteHandlerParam.dest,
			let destName = mapRouteHandlerParam.destName?.percentEncoding else {
				return nil
		}
		let urlString = String(format: "qqmap://map/routeplan?from=%@&type=drive&fromcoord=%f,%f&tocoord=%f,%f&to=%@&coord_type=1&policy=0",
							   srcName,
							   src.latitude,
							   src.longitude,
							   dest.latitude,
							   dest.longitude,
							   destName)
		return URL(string: urlString)
	}
}

public struct SoGoogleMapRouteHandler: SoMapURLRouteHandler {

	public var scheme: String = "comgooglemaps://"

	public var displayName: String = "谷歌地图"

	public var mapRouteHandlerParam: SoMapRouteHandlerParam

	public func makeURL() -> URL? {
		guard let dest = mapRouteHandlerParam.dest else {
			return nil
		}
		let urlString = String(format: "comgooglemaps://?x-source=applicationName&x-success=comgooglemaps://&saddr=&daddr=%f,%f&directionsmode=driving",
							   dest.latitude,
							   dest.longitude)
		return URL(string: urlString)
	}
}

public struct SoAppleMapRouteHandler: SoMapURLRouteHandler {

	public var scheme: String = ""

	public var displayName: String = "苹果地图"

	public var mapRouteHandlerParam: SoMapRouteHandlerParam

	public func makeURL() -> URL? {
		return nil
	}

	public func canOpenURL() -> Bool {
		return true
	}

	public func open(completionHandler: @escaping (Bool) -> ()) {

		guard let dest = mapRouteHandlerParam.dest,
			let destName = mapRouteHandlerParam.destName else {
				completionHandler(false)
				return
		}

		let userLocation = MKMapItem.forCurrentLocation()
		let toPlacemark = MKPlacemark.init(coordinate: dest)
		let toLocation = MKMapItem.init(placemark: toPlacemark)
		toLocation.name = destName
		let mapItems = [userLocation,toLocation]
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
							 MKLaunchOptionsShowsTrafficKey: NSNumber(value: true)] as [String : Any]
		MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
		completionHandler(true)
	}
}


