
//
//  UIImageExt.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2020/1/8.
//  Copyright © 2020 Teng Wang 王腾. All rights reserved.
//

import UIKit

public extension SoSwiftHelperWrapper where Core == UIImage {
	
    /// Create and return a 1x1 point size image with the given color.
    /// - Parameter color: The color.
    /// - Returns: The UIImage.
    static func make(_ color: UIColor) -> UIImage? {
        UIImage.so.make(color, size: CGSize(width: 1, height: 1))
    }
    
    /// Create and return a pure color image with the given color and size.
    /// - Parameters:
    ///   - color: The color.
    ///   - size: New image's type.
    /// - Returns: The UIImage.
	static func make(_ color: UIColor, size: CGSize) -> UIImage? {
        if (size.width <= 0 || size.height <= 0) {
            return nil
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(color.cgColor);
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
	}
    
    /// Returns a new image which is cropped from this image.
    /// - Parameter toRect: Image's inner rect.
    /// - Returns: The new image, or nil if an error occurs.
    func crop(toRect: CGRect) -> UIImage? {
        var rect = toRect
        rect.origin.x *= base.scale
        rect.origin.y *= base.scale
        rect.size.width *= base.scale
        rect.size.height *= base.scale
        guard rect.size.width > 0,  rect.size.height > 0 else {
            return nil
        }
        guard let cgImage = base.cgImage, let imageRef = cgImage.cropping(to: rect) else {
            return nil
        }
        let image = UIImage(cgImage: imageRef, scale: base.scale, orientation: base.imageOrientation)
        return image
    }

}
