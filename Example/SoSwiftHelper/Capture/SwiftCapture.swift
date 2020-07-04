//
//  SwiftCapture.swift
//  NIOSwiftHelper_Example
//
//  Created by Teng Wang 王腾 on 2020/7/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

enum CaptureStyple {
	case video
	case audio
	case all
}

class SwiftCapture: NSObject {

	var style: CaptureStyple = .all

	var perViewLayer: AVCaptureVideoPreviewLayer {
		return videoCapture.perViewLayer
	}

	lazy var videoCapture: SwiftVideoCapture = {
		let videoCapture = SwiftVideoCapture()
		videoCapture.prepare()
		return videoCapture
	}()

	lazy var audioCapture: SwiftAudioCapture = {
		let audioCapture = SwiftAudioCapture()
		audioCapture.prepare()
		return audioCapture
	}()

	convenience init(style: CaptureStyple = .all) {
		self.init()
		self.style = style
		switch style {
		case .all:
			audioCapture.delegate = self
			videoCapture.delegate = self
		case .audio:
			audioCapture.delegate = self
		case .video:
			videoCapture.delegate = self
		}
	}
	
	func setPerViewLayerSize(_ size: CGSize) {
		self.videoCapture.setPerViewLayerSize(size)
	}

	func start() {
		switch style {
		case .all:
			audioCapture.start()
			videoCapture.start()
		case .audio:
			audioCapture.start()
		case .video:
			videoCapture.start()
		}
	}

	func stop() {
		switch style {
		case .all:
			audioCapture.stop()
			videoCapture.stop()
		case .audio:
			audioCapture.stop()
		case .video:
			videoCapture.stop()
		}
	}
}

extension SwiftCapture: SwiftCaptureBufferDelegate {

	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		if connection  == audioCapture.captureConnection {
			print("audio")
		} else  if connection  == videoCapture.captureConnection {
			print("video")
		}
	}
}
