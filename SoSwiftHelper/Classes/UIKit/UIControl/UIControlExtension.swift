//
//  UIButtonExt.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2020/1/8.
//  Copyright © 2020 Teng Wang 王腾. All rights reserved.
//

import UIKit

private var buttonActionKey: Void?


private var TargetEventActionKey: Void?
public class TargetEventAction: NSObject {
    
    var block: ((UIControl)->())
    
    var control: UIControl
    
    init(control: UIControl,
         block: @escaping (UIControl)->()) {
        self.control = control
        self.block = block
        super.init()
    }
    
    @objc
    func didClick() {
        block(control)
    }
}

public extension SoSwiftHelperWrapper where Core: UIControl {
    
    /// Add a block for UIControl event
    /// - Parameters:
    ///   - event: The UIControl.Event.
    ///   - block: The block which is invoked then the action message is sent
    /// - Returns: No return.
    func addTargetEvent(_ event: UIControl.Event = .touchUpInside,
                                 block: @escaping (UIControl)->()) {
        let target = TargetEventAction(control: base, block: block)
        base.addTarget(target, action: #selector(target.didClick), for: event)
        self.targetEventAction = target
    }
    
    var targetEventAction: TargetEventAction? {
        get { return objc_getAssociatedObject(base, &TargetEventActionKey) as? TargetEventAction }
        set { objc_setAssociatedObject(base, &TargetEventActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
	
	/// Make GCD TimerSource
	/// - Parameter time: time description
	/// - Parameter deadline: deadline description
	/// - Parameter repeating: repeating description
	/// - Parameter eventHandler: eventHandler description
	/// - Parameter eventHandlerDispatchQueue: eventHandlerDispatchQueue description
	/// - Parameter stop: stop description
	func countDown(time: Int,
				   deadline: DispatchTime = .now(),
				   repeating: DispatchTimeInterval = .seconds(1),
				   eventHandler: @escaping ((Int)->Void),
				   eventHandlerDispatchQueue: DispatchQueue = .main,
				   stop: @escaping ((Int)->Bool)) {
		base.isEnabled = false
		DispatchQueue.so.countDown(time: time,
								   deadline: deadline,
								   repeating: repeating,
								   eventHandler: eventHandler,
								   eventHandlerDispatchQueue: eventHandlerDispatchQueue)
		{ (value) -> Bool in
			let stop = stop(value)
			if stop {
				DispatchQueue.main.async {
					self.base.isEnabled = true
				}
			}
			return stop
		}
	}
}

