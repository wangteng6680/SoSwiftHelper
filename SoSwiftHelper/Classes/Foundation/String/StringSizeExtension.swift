//
//  StringSize.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2020/1/6.
//  Copyright © 2020 Teng Wang 王腾. All rights reserved.
//

import UIKit

func boundingRect(string: String, _ size: CGSize, attributes: [NSAttributedString.Key : Any]) -> CGSize {
	let rectToFit = NSString(string: string).boundingRect(with: size,
														options: .usesLineFragmentOrigin,
														attributes: attributes,
														context: nil)
	return rectToFit.size
}

// MARK: - string size
public extension SoSwiftHelperWrapper where Core == String {

	func height(_ width: Float, font: UIFont) -> CGFloat {
		let boundsSize = CGSize(width: CGFloat(width), height: CGFloat.greatestFiniteMagnitude)
		return height(boundsSize, font: font)
	}

	func height(_ width: CGFloat, font: UIFont) -> CGFloat {
		let boundsSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
		return height(boundsSize, font: font)
	}

	func height(_ size: CGSize, font: UIFont) -> CGFloat {
		let attributes = [NSAttributedString.Key.font : font]
		return boundingRect(string: base, size, attributes: attributes).height
	}

	func height(_ width: Float, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
		let boundsSize = CGSize(width: CGFloat(width), height: CGFloat.greatestFiniteMagnitude)
		return boundingRect(string: base, boundsSize, attributes: attributes).height
	}

	func width(_ height: Float, font: UIFont) -> CGFloat {
		let boundsSize = CGSize(width:  CGFloat.greatestFiniteMagnitude, height: CGFloat(height))
		return width(boundsSize, font: font)
	}

	func width(_ size: CGSize, font: UIFont) -> CGFloat {
		let attributes = [NSAttributedString.Key.font : font]
		return boundingRect(string: base, size, attributes: attributes).width
	}

	func width(_ height: Float, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
		let boundsSize = CGSize(width:  CGFloat.greatestFiniteMagnitude, height: CGFloat(height))
		return boundingRect(string: base, boundsSize, attributes: attributes).width
	}
}
