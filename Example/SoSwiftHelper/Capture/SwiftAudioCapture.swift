//
//  SwiftAudioCapture.swift
//  NIOSwiftHelper_Example
//
//  Created by Teng Wang 王腾 on 2020/7/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

class SwiftAudioCapture: SwiftBaseCapture {

	lazy var audioDevice: AVCaptureDevice? = {
		guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
			return nil
		}
		return audioDevice
	}()

	lazy var input: AVCaptureDeviceInput? = {
		guard let audioDevice = audioDevice else {
			return nil
		}
		return try? AVCaptureDeviceInput(device: audioDevice)
	}()

	lazy var output: AVCaptureAudioDataOutput? = {
		let output = AVCaptureAudioDataOutput()
		output.setSampleBufferDelegate(self, queue: captureQueue)
		return output
	}()

	var captureConnection: AVCaptureConnection?

	func prepare() {
		sessionConfiguration()
		captureConnection = output?.connection(with: .audio)
	}

	private func sessionConfiguration() {
		session.beginConfiguration()
		if let input = input, session.canAddInput(input) {
			session.addInput(input)
		}
		if let output = output, session.canAddOutput(output) {
			session.addOutput(output)
		}
		session.commitConfiguration()
	}

}

extension SwiftAudioCapture: AVCaptureAudioDataOutputSampleBufferDelegate {

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
