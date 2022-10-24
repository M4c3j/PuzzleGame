//
//  CameraVC.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-19.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController, AVCapturePhotoCaptureDelegate {
	
	weak var delegate: CameraVCDelegate? = nil
	let captureSession: AVCaptureSession = AVCaptureSession()
	let photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
	var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	
	let cameraView = UIView()
	let captureButton = UIButton()
	let upperSquareMask = UIView()
	let bottomSquareMask = UIView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationItem.backButtonTitle = "Back to Menu"
		navigationController?.navigationBar.tintColor = .MyColor.pink
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		createUI()
	}
	
	func createUI() {
		setCameraPreview()
		createCameraView()
		createTopSquareMask()
		createBottomSquareMask()
		createCaptureButton()
	}
	
	func createCameraView() {
		cameraView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.minY)!, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.minY)! )
		view.addSubview(cameraView)
	}
	
	func createCaptureButton() {
		view.addSubview(captureButton)
		captureButton.translatesAutoresizingMaskIntoConstraints = false
		captureButton.addTarget(self, action: #selector(didTapCaptureButton(_ :)), for: .touchUpInside)
		captureButton.backgroundColor = .MyColor.blue
		captureButton.layer.cornerRadius = 40
		captureButton.layer.borderWidth = 10
		captureButton.layer.borderColor = UIColor.MyColor.cyan.cgColor
		
		NSLayoutConstraint.activate([
			captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
			captureButton.heightAnchor.constraint(equalToConstant: 80),
			captureButton.widthAnchor.constraint(equalToConstant: 80)
		])
	}
	
	func createTopSquareMask() {
		upperSquareMask.frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.minY)!, width: UIScreen.main.bounds.width , height: ((UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.minY)!) - UIScreen.main.bounds.width ) / 2 )
		upperSquareMask.backgroundColor = .MyColor.lightpink
		view.addSubview(upperSquareMask)
	}
	
	func createBottomSquareMask() {
		bottomSquareMask.frame = CGRect(x: 0, y: view.frame.maxY - ((UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.minY)!) - UIScreen.main.bounds.width ) / 2 , width: UIScreen.main.bounds.width , height: ((UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.minY)!) - UIScreen.main.bounds.width ) / 2 )
		bottomSquareMask.backgroundColor = .MyColor.lightpink
		view.addSubview(bottomSquareMask)
	}
	
	@objc func didTapCaptureButton(_ sender: UIButton) {
		let settings = AVCapturePhotoSettings()
		settings.flashMode = .auto
		photoOutput.capturePhoto(with: settings, delegate: self)
	}
	
	
	func setCameraPreview() {
		
		captureSession.beginConfiguration()
		captureSession.sessionPreset = .hd1280x720
		var captureDevice: AVCaptureDevice?
		captureDevice = AVCaptureDevice.default(for: .video)
		guard let captureDevice = captureDevice else { return }
		
		if AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized {
			guard
				let videoDeviceInput = try? AVCaptureDeviceInput(device: captureDevice),
				captureSession.canAddInput(videoDeviceInput) else { return }
			captureSession.addInput(videoDeviceInput)
			
			guard captureSession.canAddOutput(photoOutput) else { return }
			captureSession.addOutput(photoOutput)
			
			videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession)
			guard let videoPreviewLayer = videoPreviewLayer else { return }
			videoPreviewLayer.videoGravity = .resizeAspectFill
			videoPreviewLayer.connection?.videoOrientation = .portrait
			videoPreviewLayer.frame = self.cameraView.bounds
			
			self.videoPreviewLayer = videoPreviewLayer
			self.cameraView.layer.addSublayer(self.videoPreviewLayer!)
			
			self.captureSession.commitConfiguration()
			captureSession.startRunning()
			self.reloadInputViews()
		} else {
			AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> () in
				if granted == true {
					self.setCameraPreview()
				} else {
					self.navigationController?.popViewController(animated: true)
				}
			})
		}
	}
	
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		guard let cgImage = photo.cgImageRepresentation() else { return }
		guard let image = UIImage(cgImage: cgImage).rotate(radians: Float.pi / 2) else { return }
		let imagecropper = ImageCropper()
		self.delegate?.DidFinishCapturePhoto(imagecropper.cropImageToSquare(image)!)
		self.navigationController?.popViewController(animated: true)
	}
	
}

protocol CameraVCDelegate: AnyObject {
	
	func DidFinishCapturePhoto(_ image: UIImage)
	
}
