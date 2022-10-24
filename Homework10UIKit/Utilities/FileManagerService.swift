//
//  FileMenagerService.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-14.
//

import UIKit

class FileManagerService {
	
	let filemgr = FileManager.default
	
	func directoryExists(named directory: String) -> Bool {
		let paths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
		let docsURL = paths[0]
		let unknownDir = docsURL.appendingPathComponent(directory).path
		if filemgr.fileExists(atPath: unknownDir) {
			return true
		} else {
			print("Directory \(directory) doesn't exist")
			return false
		}
	}
	
	func fileExists(named fileName: String, ofType fileType: String, at directory: String) -> Bool {
		let paths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
		let docsURL = paths[0]
		let unknownDir = docsURL.appendingPathComponent(directory).appendingPathComponent(fileName + "." + fileType).path
		if filemgr.fileExists(atPath: unknownDir) {
			return true
		} else {
			return false
		}
	}
	
	func createDirectory(named directory: String) -> Bool {
		let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
		let docsUrl = dirPaths[0]
		let newDir = docsUrl.appendingPathComponent(directory).path
		do {
			try filemgr.createDirectory(atPath: newDir, withIntermediateDirectories: true, attributes: nil)
			return true
		} catch let error as NSError {
			print("Creating directory error: \(error.localizedDescription)")
			return false
		}
	}
	
	func saveImageToDirectory(directory: String, imageName: String, image: UIImage) -> Bool {
		let paths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
		let docsURL = paths[0]
		let unknownDir = docsURL.appendingPathComponent(directory)
		if !directoryExists(named: directory) {
			return false
		}
		let imageDir = unknownDir.appendingPathComponent("\(imageName).jpg")
		if fileExists(named: (imageName), ofType: "jpg", at: directory) {
			print("Image: '\(imageName)' already exist")
			return false
		}
		guard let image = image.jpegData(compressionQuality: 1) else {
			print("Failed to compress image")
			return false
		}
		do {
			try image.write(to: imageDir)
			return true
		}
		catch let error as NSError {
			print("Failed to save image: \(error)")
			return false
		}
	}
	
	func loadAllJPGImages(from directory: String) -> [UIImage] {
		var imageNames: [String] = []
		var images: [UIImage] = []
		let paths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
		let docsURL = paths[0]
		let unknownDir = docsURL.appendingPathComponent(directory)
		
		do {
			let items = try filemgr.contentsOfDirectory(atPath: unknownDir.path)
			imageNames = items
			imageNames = imageNames.filter({
				$0.hasSuffix(".jpg")
			})
		} catch let error as NSError {
			print("Failed to read picture names in \"\(unknownDir.path)\" directory. Error: \(error.localizedDescription)")
		}
		for name in imageNames {
			let imagePath = unknownDir.appendingPathComponent(name).path
			guard let image = UIImage(contentsOfFile: imagePath) else {
				print("Failed to read image of name: \(name) in path: \(imagePath)")
				return []
			}
			images.append(image)
		}
		return images
	}

}


/*
 let filemgr = FileManagerService()
 filemgr.createDirectory(named: "Images")
 filemgr.saveImageToDirectory(directory: "Images", imageName: "Image1", image: UIImage(named: "picture1")!)
 
 print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last)
 let currentPath = filemgr.currentDirectoryPath
 */
