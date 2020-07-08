//
//  UINavigationItem.swift
//  NIOSwiftFD
//
//  Created by Teng Wang 王腾 on 2020/3/10.
//

import UIKit

typealias SoSwiftHelperViewController = UIViewController

public extension SoSwiftHelperViewController {
    
    /// Create a barButtonItem which is used navigationItem.leftBarButtonItem
    /// - Parameters:
    ///   - image: The image
    ///   - block: The block which is invoked then the action message is sent
    /// - Returns:
	func makeNavigationLeftBar(_ image: UIImage?,
                               block: @escaping (UIButton) ->()) {
		guard let image = image else {
			return
		}
        let button = UIButton(type: .custom)
		button.frame = CGRect(origin: .zero, size: image.size)
		button.setImage( image, for: .normal)
		button.setImage( image, for: .highlighted)
		button.setImage( image, for: .selected)
        button.so.addTargetEvent { (button) in
            block(button as! UIButton)
        }
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
	}
    
	func makeNavigationRightBar(_ image: UIImage?,
					   block: @escaping (UIButton) ->()) {
		guard let image = image else {
			return
		}
		let button = UIButton(type: .custom)
		button.frame = CGRect(origin: .zero, size: image.size)
		button.setImage( image, for: .normal)
		button.setImage( image, for: .highlighted)
		button.setImage( image, for: .selected)
        button.so.addTargetEvent { (button) in
            block(button as! UIButton)
        }
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
	}
    
	func makeNavigationRightBar(_ titleText: String,
                                _ titleColor: UIColor = .darkGray,
                                _ font: UIFont = UIFont.systemFont(ofSize: 14),
                                block: @escaping (UIButton) ->()) {
		let width = titleText.so.width(Float.greatestFiniteMagnitude, font: font)
		let size =  CGSize(width: width, height: 44)
		let button = UIButton(type: .custom)
		button.frame = CGRect(origin: .zero, size: size)
		button.setTitle(titleText, for: .normal)
		button.setTitle(titleText, for: .selected)
		button.setTitle(titleText, for: .highlighted)
		button.setTitleColor(titleColor, for: .normal)
		button.setTitleColor(titleColor, for: .selected)
		button.titleLabel?.font = font
        button.so.addTargetEvent { (button) in
            block(button as! UIButton)
        }
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
	}
}
