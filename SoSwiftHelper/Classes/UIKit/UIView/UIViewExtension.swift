//
//  UIViewExt.swift
//  NIOSwiftFD
//
//  Created by Teng Wang 王腾 on 2020/4/1.
//

import UIKit

public extension SoSwiftHelperWrapper where Core : UIView {

    /// Shortcut for frame.origin.x.
	var left: CGFloat {
		set{
			let frame = CGRect(x: newValue,
							   y: top,
							   width: width,
							   height: height)
			base.frame = frame
		}
		get {
			return base.frame.origin.x
		}
	}

    /// Shortcut for frame.origin.y.
	var top: CGFloat {
		set{
			let frame = CGRect(x: left,
							   y: newValue,
							   width: width,
							   height: height)
			base.frame = frame
		}
		get {
			return base.frame.origin.y
		}
	}
     
    /// Shortcut for frame.origin.x + frame.size.width.
    var right: CGFloat {
        return left + width
    }
    
    /// Shortcut for frame.origin.y + frame.size.height.
    var bottom: CGFloat {
        return top + height
    }

    /// Shortcut for frame.origin.
	var origin: CGPoint {
		return base.frame.origin
	}

    /// Shortcut for frame.size.
	var size: CGSize {
        return base.frame.size
	}
    
    /// Shortcut for frame.size.width.
	var width: CGFloat {
		set{
			let frame = CGRect(x: left,
							   y: top,
							   width: newValue,
							   height: height)
			base.frame = frame
		}
		get {
			return base.frame.size.width
		}
	}
    
    /// Shortcut for frame.size.width
	var height: CGFloat {
		set{
			let frame = CGRect(x: left,
							   y: top,
							   width: width,
							   height: newValue)
			base.frame = frame
		}
		get {
			return base.frame.size.width
		}
	}
}
