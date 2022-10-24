//
//  ImageCropper.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-13.
//

import UIKit

struct ImageCropper {
	
	var imageToCrop: CGImage = (UIImage(named: "picture1")?.cgImage)!
	
	func cropImageTo16Parts(_ image: UIImage) -> [ImageWithID] {
		var croppedImage: [ImageWithID] = []
		guard let imageUnwrapped = image.cgImage else { return [] }
		croppedImage.removeAll()
		let size: CGFloat = CGFloat(imageUnwrapped.width / 4)
		var x: CGFloat = 0
		var y: CGFloat = 0
		var id = 1
		for _ in 0...3 {
			for _ in 0...3 {
				guard let partOfImage = imageUnwrapped.cropping(to: CGRect(x: CGFloat(imageUnwrapped.width) * y,
																		   y: CGFloat(imageUnwrapped.height) * x,
																		   width: size,
																		   height: size))
				else { return [] }
				croppedImage.append(ImageWithID(id: id, image: UIImage(cgImage: partOfImage)))
				id += 1
				y += 0.25
			}
			y = 0
			x += 0.25
		}
		return croppedImage
	}
	
	func cropImageToSquare(_ image: UIImage) -> UIImage? {
		var imageShorterSide: Int = 0
		guard let imageUnwrapped = image.cgImage else { return nil }
		if imageUnwrapped.width > imageUnwrapped.height {
			imageShorterSide = imageUnwrapped.height
			let xStartingPoint = (imageUnwrapped.width - imageShorterSide) / 2
			guard let croppedCGImage = imageUnwrapped.cropping(to: CGRect(x: xStartingPoint,
																		  y: 0,
																		  width: imageShorterSide,
																		  height: imageShorterSide)) else {
				print("Failed to crop image")
				return nil
			}
			return UIImage(cgImage: croppedCGImage)
		} else if imageUnwrapped.width < imageUnwrapped.height {
			imageShorterSide = imageUnwrapped.width
			let yStartingPoint = (imageUnwrapped.height - imageShorterSide) / 2
			guard let croppedCGImage = imageUnwrapped.cropping(to: CGRect(x: 0,
																		  y: yStartingPoint,
																		  width: imageShorterSide,
																		  height: imageShorterSide)) else {
				print("Failed to crop image")
				return nil
			}
			return UIImage(cgImage: croppedCGImage)
		} else {
			return UIImage(cgImage: imageUnwrapped)
		}
	}

}
