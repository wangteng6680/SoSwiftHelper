//
//  SwiftVideoCapture.swift
//  NIOSwiftHelper_Example
//
//  Created by Teng Wang 王腾 on 2020/7/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

class SwiftVideoCapture: SwiftBaseCapture {

	lazy var perViewLayer: AVCaptureVideoPreviewLayer = {
		let perViewLayer = AVCaptureVideoPreviewLayer.init(session: session)
		perViewLayer.masksToBounds = true
		perViewLayer.videoGravity = .resizeAspectFill
		return perViewLayer
	}()

	lazy var input: AVCaptureDeviceInput? = {
		guard let videoDevice = currentCaptureDevice else {
			return nil
		}
		return try? AVCaptureDeviceInput(device: videoDevice)
	}()

	lazy var output: AVCaptureVideoDataOutput? = {
		let output = AVCaptureVideoDataOutput()
		output.setSampleBufferDelegate(self, queue: captureQueue)
		output.alwaysDiscardsLateVideoFrames = true
		output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
		return output
	}()

	var captureConnection: AVCaptureConnection?

	/// 前置摄像头
	var frontCapture: AVCaptureDevice?
	/// 后置摄像头
	var backCapture: AVCaptureDevice?

	/// 当前采集的摄像头
	var currentCaptureDevice: AVCaptureDevice?

	var perViewLayerSize: CGSize = .zero

	func prepare(){

		/// 获取前后摄像头
		self.frontCapture = getVideoCaptureDevice(.front)
		self.backCapture = getVideoCaptureDevice(.back)

		/// 设置当前采集摄像头为后置摄像头
		self.currentCaptureDevice = self.backCapture

		sessionConfiguration()

		captureConnection = output?.connection(with: .video)
		captureConnection?.videoOrientation = .portrait

		/// 防止抖动
		if let captureConnection = captureConnection,
			captureConnection.isVideoStabilizationSupported {
			captureConnection.preferredVideoStabilizationMode = .auto
		}
	}

	func setPerViewLayerSize(_ size: CGSize) {
		self.perViewLayerSize = size
		self.perViewLayer.frame = CGRect(x: 0, y: 0,
										 width: size.width,
										 height: size.height)
	}

	func sessionConfiguration() {

		/// 设置分辨率
		if session.canSetSessionPreset(.high) {
			session.sessionPreset = .high
		}

		session.beginConfiguration()
		if let input = input, session.canAddInput(input) {
			session.addInput(input)
		}
		if let output = output, session.canAddOutput(output) {
			session.addOutput(output)
		}
		session.commitConfiguration()
	}

	func getVideoCaptureDevice(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
		let discoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera],
													 mediaType: .video,
													 position: position)
		for captureDevice in discoverySession.devices {
			if captureDevice.position == position {
				return captureDevice
			}
		}
		return nil
	}
}

extension SwiftVideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {

	/// 音频采集输出
	/// - Parameters:
	///   - output: AVCaptureOutput
	///   - sampleBuffer: CMSampleBuffer
	///   - connection: AVCaptureConnection
	func captureOutput(_ output: AVCaptureOutput,
					   didOutput sampleBuffer: CMSampleBuffer,
					   from connection: AVCaptureConnection) {
		delegate?.captureOutput(output, didOutput: sampleBuffer, from: connection)
	}
}
