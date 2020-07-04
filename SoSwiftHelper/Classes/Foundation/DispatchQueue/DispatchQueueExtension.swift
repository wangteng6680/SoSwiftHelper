
//
//  DispatchQueueExt.swift
//  NIOFD
//
//  Created by Teng Wang 王腾 on 2020/1/8.
//  Copyright © 2020 Teng Wang 王腾. All rights reserved.
//

import Foundation

public typealias Task = () -> Void

public extension SoSwiftHelperWrapper where Core == DispatchQueue {
	
	// This method will dispatch the `block` to self.
	// If `self` is the main queue, and current thread is main thread, the block
	// will be invoked immediately instead of being dispatched.
	func mainAsync(_ block: @escaping ()->()) {
		if base === DispatchQueue.main && Thread.isMainThread {
			block()
		} else {
			base.async { block() }
		}
	}
	
	/// countDown
	/// - Parameter time: time description
	/// - Parameter deadline: deadline description
	/// - Parameter repeating: repeating description
	/// - Parameter eventHandler: eventHandler description
	/// - Parameter eventHandlerDispatchQueue: eventHandlerDispatchQueue description
	/// - Parameter stop: stop description
	static func countDown(time: Int,
						  deadline: DispatchTime = .now(),
						  repeating: DispatchTimeInterval = .seconds(1),
						  eventHandler: @escaping ((Int)->Void),
						  eventHandlerDispatchQueue: DispatchQueue = .main,
						  stop: @escaping ((Int)->Bool)) {
		var countTime: Int = time
		let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
		codeTimer.schedule(deadline: deadline, repeating: repeating)
		codeTimer.setEventHandler(handler: {
			countTime -= 1
			eventHandlerDispatchQueue.async {
				eventHandler(countTime)
			}
			if stop(countTime) {
				codeTimer.cancel()
			}
		})
		codeTimer.resume()
	}

	/// 在子线程执行任务
	///
	/// - Parameter task: 执行任务
	static func async(_ task: @escaping Task) {
		_async(task)
	}

	/// 在子线程执行任务并回到主线程
	///
	/// - Parameters:
	///   - task: 子线程的任务
	///   - mainTask: 主线程的任务
	static func async(_ task: @escaping Task, _ mainTask: @escaping Task) {
		_async(task, mainTask)
	}

	private static func _async(_ task: @escaping Task,
							   _ mainTask: Task? = nil) {
		let workItem = DispatchWorkItem(block: task)
		DispatchQueue.global().async(execute: workItem)
		if let mainTask = mainTask {
			workItem.notify(queue: DispatchQueue.main, execute: mainTask)
		}
	}

	/// 在主线程中延迟执行任务
	///
	/// - Parameters:
	///   - seconds: 延迟执行的时间（单位: S）
	///   - task: 子线程延迟执行的任务
	/// - Returns: DispatchWorkItem
	@discardableResult
	static func delay(_ seconds: TimeInterval, _ task: @escaping Task) -> DispatchWorkItem {
		let workItem = DispatchWorkItem(block: task)
		let deadline = DispatchTime.now()+seconds
		DispatchQueue.main.asyncAfter(deadline: deadline, execute: workItem)
		return workItem
	}

	/// 在子线程延迟执行任务
	///
	/// - Parameters:
	///   - second: 延迟执行的时间（单位: S）
	///   - task: 子线程延迟执行的任务
	/// - Returns: DispatchWorkItem
	@discardableResult
	static func asyncDelay(_ second: TimeInterval,
						   _ task: @escaping Task) -> DispatchWorkItem {
		return _asyncDelay(second, task)
	}

	/// 在子线程延迟执行任务并回到主线程
	///
	/// - Parameters:
	///   - second: 延迟执行的时间（单位: S）
	///   - task: 子线程延迟执行的任务
	///   - mainTask: 主线程任务
	/// - Returns: DispatchWorkItem
	@discardableResult
	static func asyncDelay(_ second: TimeInterval,
						   _ task: @escaping Task,
						   _ mainTask: Task? = nil) -> DispatchWorkItem {
		return _asyncDelay(second, task, mainTask)
	}

	@discardableResult
	private static func _asyncDelay(_ second: TimeInterval,
									_ task: @escaping Task,
									_ mainTask: Task? = nil) -> DispatchWorkItem {

		let workItem = DispatchWorkItem(block: task)
		let deadline = DispatchTime.now()+second
		DispatchQueue.global().asyncAfter(deadline: deadline, execute: workItem)
		if let mainTask = mainTask {
			workItem.notify(queue: DispatchQueue.main, execute: mainTask)
		}
		return workItem
	}
}


