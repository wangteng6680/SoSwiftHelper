//
//  UIDeviceExt.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2020/1/7.
//  Copyright © 2020 Teng Wang 王腾. All rights reserved.
//

import UIKit

#if os(iOS)
// MARK: - Battery
public extension SoSwiftHelperWrapper where Core == UIDevice  {
    
    // MARK: - Orientation
    /**
    This enum describes the state of the orientation.
    - Landscape: The FDDevice is in Landscape Orientation
    - Portrait:  The FDDevice is in Portrait Orientation
    */
    enum Orientation {
        case landscape
        case portrait
    }

    var orientation: Orientation {
        if UIDevice.current.orientation.isLandscape {
            return .landscape
        } else {
            return .portrait
        }
    }
	/**
	This enum describes the state of the battery.

	- Full:      The FDDevice is plugged into power and the battery is 100% charged or the FDDevice is the iOS Simulator.
	- Charging:  The FDDevice is plugged into power and the battery is less than 100% charged.
	- Unplugged: The FDDevice is not plugged into power; the battery is discharging.
	*/
	enum BatteryState: CustomStringConvertible, Equatable {
		/// The FDDevice is plugged into power and the battery is 100% charged or the FDDevice is the iOS Simulator.
		case full
		/// The FDDevice is plugged into power and the battery is less than 100% charged.
		/// The associated value is in percent (0-100).
		case charging(Int)
		/// The FDDevice is not plugged into power; the battery is discharging.
		/// The associated value is in percent (0-100).
		case unplugged(Int)

		fileprivate init() {
			let wasBatteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled
			UIDevice.current.isBatteryMonitoringEnabled = true
			let batteryLevel = Int(round(UIDevice.current.batteryLevel * 100)) // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
			// but maybe that changes in the future.
			switch UIDevice.current.batteryState {
			case .charging: self = .charging(batteryLevel)
			case .full: self = .full
			case .unplugged:self = .unplugged(batteryLevel)
			case .unknown: self = .full // Should never happen since `batteryMonitoring` is enabled.
			@unknown default:
				self = .full
			}
			UIDevice.current.isBatteryMonitoringEnabled = wasBatteryMonitoringEnabled
		}

		/// The user enabled Low Power mode
		var lowPowerMode: Bool {
			if #available(iOS 9.0, *) {
				return ProcessInfo.processInfo.isLowPowerModeEnabled
			} else {
				return false
			}
		}

		/// Provides a textual representation of the battery state.
		/// Examples:
		/// ```
		/// Battery level: 90%, FDDevice is plugged in.
		/// Battery level: 100 % (Full), FDDevice is plugged in.
		/// Battery level: \(batteryLevel)%, FDDevice is unplugged.
		/// ```
		public var description: String {
			switch self {
			case .charging(let batteryLevel): return "Battery level: \(batteryLevel)%, FDDevice is plugged in."
			case .full: return "Battery level: 100 % (Full), FDDevice is plugged in."
			case .unplugged(let batteryLevel): return "Battery level: \(batteryLevel)%, FDDevice is unplugged."
			}
		}

	}

	/// The state of the battery
	var batteryState: BatteryState {
		return BatteryState()
	}

	/// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
	var batteryLevel: Int {
		switch BatteryState() {
		case .charging(let value): return value
		case .full: return 100
		case .unplugged(let value): return value
		}
	}
    
    /// Gets the identifier from the system, such as "iPhone7,1".
    static var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)

        let identifier = mirror.children.reduce("") { identifier, element in
         guard let value = element.value as? Int8, value != 0 else { return identifier }
         return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
     
    /// The name identifying the FDDevice (e.g. "Dennis' iPhone").
    var name: String {
        return UIDevice.current.name
    }

    /// The name of the operating system running on the FDDevice represented by the receiver (e.g. "iOS" or "tvOS")
    var systemName: String {
        return UIDevice.current.systemName
    }
    
    /// Whether the device is iPad/iPad mini.
    var isPad: Bool {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }
    
    var isSimulator: Bool {
        #if TARGET_OS_SIMULATOR
          return true;
        #else
          return false;
        #endif
    }

    /// The current version of the operating system (e.g. 8.4 or 9.2).
    var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    /// The model of the FDDevice (e.g. "iPhone" or "iPod Touch").
    var model: String {
        return UIDevice.current.model
    }

    /// The model of the FDDevice as a localized string.
    var localizedModel: String {
        return UIDevice.current.localizedModel
    }
    
    ///
    /// - Returns: 获取不到返回 ""
    static func ipAddresses() -> String {
        var addresses: [String] = []
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    // // Check for IPv4 or IPv6 interface:  UInt8(AF_INET6)
                    if addr.sa_family == UInt8(AF_INET) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil,           socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? ""
    }

}
#endif
