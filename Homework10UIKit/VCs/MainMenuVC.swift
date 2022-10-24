//
//  MainMenuVCViewController.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-13.
//

import UIKit
import AVFoundation

class MainMenuVC: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
	
	let titleText = UILabel()
	let choosePhotoText = UILabel()
	let photosCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	let photosCollectionLayout = UICollectionViewFlowLayout()
	let alternativeOptionsText = UILabel()
	let takePictureButton = UIButton()
	let galleryButton = UIButton()
	let playButton = UIButton()
	let textColor = UIColor.MyColor.pink
	let pictureName = "picture1"
	
	var images: [UIImage] = []
	let imagesDirectory = "Images"
	
	var imagePicker = UIImagePickerController()
	
	var presentGallery = false
	
	var selectedPicture = UIImage()
	var selectedPictureIndexPath = IndexPath()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		loadImages()
		view.backgroundColor = UIColor.MyColor.background
		createUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
		photosCollection.reloadData()
	}
    	func createUI() {
		createTitleText()
		createChoosePhotoText()
		registerCell()
		createPhotosCollection()
		createAlternativeOptionsText()
		createtakePictureButton()
		createGalleryButton()
		createPlayButton()
		setupLongGestureRecognizerOnCollection()
	}
	
	func loadImages() {
		let fileMgr = FileManagerService()
		fileMgr.createDirectory(named: imagesDirectory)
		fileMgr.saveImageToDirectory(directory: imagesDirectory, imageName: "Picture0", image: UIImage(named: "picture1")!)
		let imagesFromDirectory = fileMgr.loadAllJPGImages(from: imagesDirectory)
		for image in imagesFromDirectory {
			images.append(image)
		}
	}
	
	// MARK: - TITLE TEXT
	func createTitleText() {
		view.addSubview(titleText)
		titleText.translatesAutoresizingMaskIntoConstraints = false
		titleText.text = "PUZZLEGAME"
		titleText.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
		titleText.textColor = textColor
		NSLayoutConstraint.activate([
			titleText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
			titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
	}
	// MARK: - CHOOSE PHOTO TEXT
	func createChoosePhotoText() {
		view.addSubview(choosePhotoText)
		choosePhotoText.translatesAutoresizingMaskIntoConstraints = false
		choosePhotoText.text = "Choose photo"
		choosePhotoText.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		choosePhotoText.textColor = textColor
		NSLayoutConstraint.activate([
			choosePhotoText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 50),
			choosePhotoText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
	}
	// MARK: - ALTERNATIVE OPTIONS TEXT
	func createAlternativeOptionsText() {
		view.addSubview(alternativeOptionsText)
		alternativeOptionsText.translatesAutoresizingMaskIntoConstraints = false
		alternativeOptionsText.text = "Add your own photo"
		alternativeOptionsText.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		alternativeOptionsText.textColor = textColor
		NSLayoutConstraint.activate([
			alternativeOptionsText.topAnchor.constraint(equalTo: photosCollection.bottomAnchor, constant: 80),
			alternativeOptionsText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
 // MARK: - TAKE PICTURE BUTTON
	func createtakePictureButton() {
		view.addSubview(takePictureButton)
		takePictureButton.translatesAutoresizingMaskIntoConstraints = false
		takePictureButton.backgroundColor = UIColor.MyColor.lightpink
		takePictureButton.layer.cornerRadius = 10
		takePictureButton.clipsToBounds = true
		let sfSymbol = UIImageView()
		sfSymbol.image = UIImage(systemName: "camera")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.MyColor.pink]))
		sfSymbol.translatesAutoresizingMaskIntoConstraints = false
		sfSymbol.contentMode = .scaleAspectFill
		let label = UILabel()
		takePictureButton.addSubview(label)
		label.text = "Take photo"
		label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		label.textColor = .MyColor.pink
		label.translatesAutoresizingMaskIntoConstraints = false
		takePictureButton.addSubview(sfSymbol)
		NSLayoutConstraint.activate([
			takePictureButton.heightAnchor.constraint(equalToConstant: 100),
			takePictureButton.widthAnchor.constraint(equalToConstant: 120),
			takePictureButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
			takePictureButton.topAnchor.constraint(equalTo: alternativeOptionsText.bottomAnchor, constant: 30),
			sfSymbol.centerXAnchor.constraint(equalTo: takePictureButton.centerXAnchor),
			sfSymbol.centerYAnchor.constraint(equalTo: takePictureButton.centerYAnchor, constant: -10),
			sfSymbol.heightAnchor.constraint(equalToConstant: 50),
			label.topAnchor.constraint(equalTo: sfSymbol.bottomAnchor, constant: 5),
			label.centerXAnchor.constraint(equalTo: takePictureButton.centerXAnchor)
		])
		takePictureButton.addTarget(self, action: #selector(takePhotoButtonPressed(_ :)), for: .touchUpInside)
	}
	// MARK: - GALLERY BUTTON
	func createGalleryButton() {
		view.addSubview(galleryButton)
		galleryButton.translatesAutoresizingMaskIntoConstraints = false
		galleryButton.backgroundColor = UIColor.MyColor.lightpink
		galleryButton.layer.cornerRadius = 10
		galleryButton.clipsToBounds = true
		let sfSymbol = UIImageView()
		sfSymbol.image = UIImage(systemName: "camera")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.MyColor.pink]))
		sfSymbol.translatesAutoresizingMaskIntoConstraints = false
		sfSymbol.contentMode = .scaleAspectFill
		let label = UILabel()
		galleryButton.addSubview(label)
		label.text = "Gallery"
		label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		label.textColor = .MyColor.pink
		label.translatesAutoresizingMaskIntoConstraints = false
		galleryButton.addSubview(sfSymbol)
		galleryButton.addTarget(self, action: #selector(galleryButtonPressed(_:)), for: .touchUpInside)
		NSLayoutConstraint.activate([
			galleryButton.heightAnchor.constraint(equalToConstant: 100),
			galleryButton.widthAnchor.constraint(equalToConstant: 120),
			galleryButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
			galleryButton.topAnchor.constraint(equalTo: alternativeOptionsText.bottomAnchor, constant: 30),
			sfSymbol.centerXAnchor.constraint(equalTo: galleryButton.centerXAnchor),
			sfSymbol.centerYAnchor.constraint(equalTo: galleryButton.centerYAnchor, constant: -10),
			sfSymbol.heightAnchor.constraint(equalToConstant: 50),
			label.topAnchor.constraint(equalTo: sfSymbol.bottomAnchor, constant: 5),
			label.centerXAnchor.constraint(equalTo: galleryButton.centerXAnchor)
		])
	}
	// MARK: - PLAY BUTTON
	func createPlayButton() {
		view.addSubview(playButton)
		playButton.translatesAutoresizingMaskIntoConstraints = false
		playButton.backgroundColor = UIColor.MyColor.lightpink
		playButton.layer.cornerRadius = 25
		playButton.clipsToBounds = true
		let label = UILabel()
		playButton.addSubview(label)
		label.text = "PLAY"
		label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
		label.textColor = .MyColor.pink
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
			playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			playButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
			playButton.heightAnchor.constraint(equalToConstant: 50),
			label.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
		])
		playButton.addTarget(self, action: #selector(didTapPlayButton(_:)), for: .touchUpInside)
	}
	
	@objc func didTapPlayButton(_ sender: UIButton) {
		let imageCropper = ImageCropper()
		let vc = PuzzleBoardVC()
		vc.smallCellImages = imageCropper.cropImageTo16Parts(selectedPicture)
		navigationController?.pushViewController(vc, animated: true)
	}
}

// MARK: - PHOTOS COLLECTION
extension MainMenuVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
	
	func createPhotosCollection() {
		photosCollectionLayout.minimumLineSpacing = 12
		photosCollectionLayout.minimumInteritemSpacing = 12
		photosCollectionLayout.scrollDirection = .horizontal
		view.addSubview(photosCollection)
		photosCollection.translatesAutoresizingMaskIntoConstraints = false
		photosCollection.delegate = self
		photosCollection.dataSource = self
		photosCollection.collectionViewLayout = photosCollectionLayout
		photosCollection.backgroundColor = .MyColor.background
		NSLayoutConstraint.activate([
			photosCollection.topAnchor.constraint(equalTo: choosePhotoText.bottomAnchor, constant: 10),
			photosCollection.heightAnchor.constraint(equalToConstant: 130),
			photosCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			photosCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
	
	func registerCell() {
		self.photosCollection.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseIdentifier)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		images.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 120, height: 120)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cellUnwrapped = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseIdentifier, for: indexPath) as? CustomCell else {
			let basicCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseIdentifier, for: indexPath)
			return basicCell
		}
		cellUnwrapped.image.image = images[indexPath.row]
		cellUnwrapped.layer.cornerRadius = 5
		cellUnwrapped.clipsToBounds = true
		cellUnwrapped.layer.borderColor = UIColor.MyColor.pink.cgColor
		if indexPath == selectedPictureIndexPath {
			cellUnwrapped.layer.borderWidth = 5
		} else {
			cellUnwrapped.layer.borderWidth = 0
		}
		return cellUnwrapped
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedPicture = images[indexPath.row]
		selectedPictureIndexPath = indexPath
		self.photosCollection.reloadData()
		collectionView.deselectItem(at: indexPath, animated: true)
	}
	
	func setupLongGestureRecognizerOnCollection() {
		let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
		longPressedGesture.minimumPressDuration = 0.5
		longPressedGesture.delegate = self
		longPressedGesture.delaysTouchesBegan = true
		photosCollection.addGestureRecognizer(longPressedGesture)
	}
	
	@objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
		if (gestureRecognizer.state != .began) {
			return
		}
		let p = gestureRecognizer.location(in: photosCollection)
		if let indexPath = photosCollection.indexPathForItem(at: p) {
			self.images[indexPath.row] = images[indexPath.row].rotate(radians: Float.pi / 2)!
			photosCollection.reloadItems(at: [indexPath])
		}
	}
}

// MARK: - TAKE PHOTO
extension MainMenuVC: CameraVCDelegate {
	
	@objc func takePhotoButtonPressed (_ sender: UIButton) {
		let vc = CameraVC()
		vc.delegate = self
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.backgroundColor = .MyColor.lightpink
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func DidFinishCapturePhoto(_ image: UIImage) {
		let fileMgr = FileManagerService()
		fileMgr.saveImageToDirectory(directory: imagesDirectory, imageName: "Picture\(images.count)", image: image)
		self.images.append(image)
		photosCollection.reloadData()
	}
	
}

// MARK: - SHOW GALLERY
extension MainMenuVC: UIImagePickerControllerDelegate {
	
	@objc func galleryButtonPressed (_ Sender: UIButton) {
		setupImagePicker()
	}
	
	func setupImagePicker() {
		guard
			UIImagePickerController.isSourceTypeAvailable(.photoLibrary),
			UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil
		else { return }
		let imagePicker = UIImagePickerController()
		imagePicker.mediaTypes = ["public.image"]
		imagePicker.delegate = self
		present(imagePicker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.originalImage] as? UIImage else {
			print("false")
			return
		}
		let imageCropper = ImageCropper()
		guard let croppedImage = imageCropper.cropImageToSquare(image) else { return }
		self.images.append(croppedImage)
		let fileMgr = FileManagerService()
		fileMgr.saveImageToDirectory(directory: imagesDirectory, imageName: "Picture\(images.count)", image: croppedImage)
		photosCollection.reloadData()
		dismiss(animated: true)
	}
	
}




#if DEBUG
import SwiftUI
struct ViewController_Previews: PreviewProvider {
	static var previews: some View = Preview(for: MainMenuVC())
}
#endif

