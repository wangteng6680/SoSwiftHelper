//
//  SwiftBaseCapture.swift
//  NIOSwiftHelper_Example
//
//  Created by Teng Wang 王腾 on 2020/7/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

protocol SwiftCaptureBufferDelegate: AnyObject {
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
}

class SwiftBaseCapture: NSObject {

	weak var delegate: SwiftCaptureBufferDelegate?

	let captureQueue = DispatchQueue(label: "com.swift.capture")

	lazy var session: AVCaptureSession = {
		let session = AVCaptureSession()
		return session
	}()

	func start() {
		if !session.isRunning {
			captureQueue.async { [weak self] in
				self?.session.startRunning()
			}
		}
	}

	func stop() {
		if session.isRunning {
			captureQueue.async { [weak self] in
				self?.session.stopRunning()
			}
		}
	}
}
