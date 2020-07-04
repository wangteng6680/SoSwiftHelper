//
//  UIApplication.swift
//  NIOSwiftFD
//
//  Created by Teng Wang 王腾 on 2020/3/25.
//

import UIKit

public extension SoSwiftHelperWrapper where Core == UIApplication {

	var emptyURL: URL {
		return URL(fileURLWithPath: "")
	}

	/// "Documents" folder in this app's sandbox.
	var documentsURL: URL {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? emptyURL
	}

	/// "Documents" folder in this app's sandbox.
	var documentsPath: String {
		return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
	}

	/// "Caches" folder in this app's sandbox.
	var cachesURL: URL {
		return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first ?? emptyURL
	}

	/// "Caches" folder in this app's sandbox.
	var cachesPath: String {
		return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
	}

	/// "Library" folder in this app's sandbox.
	var libraryURL: URL {
		return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first ?? emptyURL
	}

	/// "Library" folder in this app's sandbox.
	var libraryPath: String {
		return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
	}

	/// Application's Bundle Name (show in SpringBoard).
	var appBundleName: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
	}

	/// Application's Version.  e.g. "1.2.0"
	var appVersion: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}

	/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"
	var appBundleID: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
	}

	/// Application's Build number. e.g. "123"
	var appBuildVersion: String? {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
	}

	var appInfoDictionary: [String: Any]? {
		return Bundle.main.infoDictionary
	}
}
