//
//  CameraService.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-17.
//
/*
import UIKit
import AVFoundation

class CameraService {
	
	
	weak var delegate = AVCapturePhotoCaptureDelegate()
	
	let output = AVCapturePhotoOutput()
	let videoPreviewLayer = AVCaptureVideoPreviewLayer()
	
	
	func takePhoto(delegateForPreviewLayer: UIViewController) -> UIImage? {
		
		captureSession.beginConfiguration()
		let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
		
		guard
			let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
			captureSession.canAddInput(videoDeviceInput)
		else { return nil }
		
		captureSession.addInput(videoDeviceInput)
		
		let photoOutput = AVCapturePhotoOutput()
		guard captureSession.canAddOutput(photoOutput) else { return nil }
		captureSession.sessionPreset = .iFrame1280x720
		captureSession.addOutput(photoOutput)
		captureSession.commitConfiguration()
		
		
		videoPreviewLayer.videoGravity = .resizeAspectFill
		videoPreviewLayer.connection?.videoOrientation = .portrait
		delegateForPreviewLayer.layer?.addSublayer(videoPreviewLayer)
	}

}
*/

/*

 
 */

/*
 func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
 self.delegate = delegate
 }
 
 private func checkPermission(completion: @escaping (Error?) -> ()) {
 switch AVCaptureDevice.authorizationStatus(for: .video) {
 case .notDetermined:
 AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
 guard granted else { return }
 DispatchQueue.main.async {
 self?.setupCamera(completion: completion)
 }
 }
 case .restricted:
 break
 case .denied:
 break
 case .authorized:
 setupCamera(completion: completion)
 @unknown default:
 break
 }
 }
 
 private func setupCamera(completion: @escaping (Error?) -> ()) {
 let session = AVCaptureSession()
 if let device = AVCaptureDevice.default(for: .video) {
 do {
 let input = try AVCaptureDeviceInput(device: device)
 if session.canAddInput(input) {
 session.addInput(input)
 }
 if session.canAddOutput(output) {
 session.addOutput(output)
 }
 previewLayer.videoGravity = .resizeAspectFill
 //				previewLayer.connection?.videoOrientation = .portrait
 previewLayer.session = session
 //				session.sessionPreset = .iFrame1280x720
 session.startRunning()
 self.session = session
 } catch {
 completion(error)
 }
 }
 }
 
 func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
 output.capturePhoto(with: settings, delegate: delegate!)
 }
 */
