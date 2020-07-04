//
//  UIColorExt.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2020/1/7.
//  Copyright © 2020 Teng Wang 王腾. All rights reserved.
//

import UIKit

public extension SoSwiftHelperWrapper where Core == UIColor {
	
    /// Create and Return a Color for given red green blue and transparency.
    /// - Parameters:
    ///   - red: The red.
    ///   - green: The green.
    ///   - blue: The blue.
    ///   - transparency: The transparency.
    /// - Returns: New Color
	static func make(red: Int,
                     green: Int,
                     blue: Int,
                     transparency: CGFloat = 1) -> UIColor? {

		guard red >= 0 && red <= 255 else { return nil }
		guard green >= 0 && green <= 255 else { return nil }
		guard blue >= 0 && blue <= 255 else { return nil }
		var trans = transparency
		if trans < 0 { trans = 0 }
		if trans > 1 { trans = 1 }
		return UIColor.init(red: CGFloat(red),
							green: CGFloat(green),
							blue: CGFloat(blue),
							alpha: trans)
	}

	/// Create a color by hexString and transparency
	/// - Parameter hexString: 0xBCBCBC  or #BCBCBC
	/// - Parameter transparency: fd_transparency
	static func make(_ hexString: String, transparency: CGFloat = 1) -> UIColor?  {
		var string = ""
		if hexString.lowercased().hasPrefix("0x") {
			string =  hexString.replacingOccurrences(of: "0x", with: "")
		} else if hexString.hasPrefix("#") {
			string = hexString.replacingOccurrences(of: "#", with: "")
		} else {
			string = hexString
		}

		if string.count == 3 { // convert hex to 6 digit format if in short format
			var str = ""
			string.forEach { str.append(String(repeating: String($0), count: 2)) }
			string = str
		}

		guard let hexValue = Int(string, radix: 16) else { return nil }

		var trans = transparency
		if trans < 0 { trans = 0 }
		if trans > 1 { trans = 1 }

		let red = (hexValue >> 16) & 0xff
		let green = (hexValue >> 8) & 0xff
		let blue = hexValue & 0xff
		return UIColor.init(red: CGFloat(red),
							green: CGFloat(green),
							blue: CGFloat(blue),
							alpha: trans)
	}

	/// FDFoundation: Random color.
	static var random: UIColor {
		let r = Int(arc4random_uniform(255))
		let g = Int(arc4random_uniform(255))
		let b = Int(arc4random_uniform(255))
		return UIColor.so.make(red: r, green: g, blue: b) ?? .red
	}

	/// FDFoundation: Hexadecimal value string (read-only).
	var hexString: String {
		let components: [Int] = {
			let c = base.cgColor.components!
			let components = c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
			return components.map { Int($0 * 255.0) }
		}()
		return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
	}

	/// FDFoundation: Alpha of Color (read-only).
	var alpha: CGFloat {
		return base.cgColor.alpha
	}
}

