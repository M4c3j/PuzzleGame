//
//  ViewController.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-07.
//

import UIKit

class PuzzleBoardVC: UIViewController {
	
	let imageCropper = ImageCropper()
	
	let sortedItemsIDs = [1,5,9,13,2,6,10,14,3,7,11,15,4,8,12,16]
	var smallCellImages: [ImageWithID] = []
	var bigCellImages: [ImageWithID] = []
	
	let smallLayout = UICollectionViewFlowLayout()
	let bigLayout = UICollectionViewFlowLayout()
	let newGameButton = UIButton()
	var timer: Timer = Timer()
	let timerLabel = UILabel()
	var timerString: String = "0:00:00"
	var timerSeconds: Int = 0
	let movesCounterLabel = UILabel()
	var movesCounter: Int = 0
	
	var smallCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	var bigCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	
	let smallCellSize = (UIScreen.main.bounds.width - 10) / 6 - 2
	let bigCellSize = UIScreen.main.bounds.width / 4 - 4
	let collectionWidth = UIScreen.main.bounds.width - 10
	
	let defaultImageWithID = ImageWithID(id: 0, image: UIImage(systemName: "puzzlepiece.extension")!)
	var selectionStatus = SelectedItem(image: ImageWithID(id: 0, image: UIImage(systemName: "puzzlepiece.extension")!), indexPath: IndexPath(), selectionStatus: .notSelected)
	let selectionColor = UIColor.MyColor.blue.cgColor
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .MyColor.background
		populateBigEmptyImages()
		
		smallCellImages = smallCellImages.shuffled()
		createNewGameButton()
		createTimerLabel()
		createMovesCounterLabel()
		createSmallCollection()
		createBigCollection()
		registerCells()
		startTimer()
	}
	
}

extension PuzzleBoardVC {
	
	func createNewGameButton() {
		view.addSubview(newGameButton)
		newGameButton.translatesAutoresizingMaskIntoConstraints = false
		newGameButton.backgroundColor = .MyColor.lightpink
		newGameButton.setTitle("New Game", for: .normal)
		newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
		newGameButton.setTitleColor(UIColor.MyColor.background, for: .normal)
		newGameButton.layer.cornerRadius = 10
		NSLayoutConstraint.activate([
			newGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			newGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			newGameButton.widthAnchor.constraint(equalToConstant: 100),
			newGameButton.heightAnchor.constraint(equalToConstant: 40)
		])
		newGameButton.addTarget(self, action: #selector(didTapCreateNewGameButton(_:)), for: .touchUpInside)
	}
	
	@objc func didTapCreateNewGameButton(_ sender: UIButton) {
		let alert = UIAlertController(title: "New Game", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
			self.navigationController?.popViewController(animated: true)
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel))
		self.present(alert, animated: true)
	}
	
	func createTimerLabel() {
		view.addSubview(timerLabel)
		timerLabel.translatesAutoresizingMaskIntoConstraints = false
		timerLabel.text = timerString
		timerLabel.textColor = .MyColor.pink
		timerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		NSLayoutConstraint.activate([
			timerLabel.centerYAnchor.constraint(equalTo: newGameButton.centerYAnchor),
			timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			timerLabel.widthAnchor.constraint(equalToConstant: 100)
		])
	}
	
	func createMovesCounterLabel() {
		view.addSubview(movesCounterLabel)
		movesCounterLabel.translatesAutoresizingMaskIntoConstraints = false
		movesCounterLabel.text = "Moves: \(movesCounter)"
		movesCounterLabel.textColor = .MyColor.pink
		movesCounterLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
		movesCounterLabel.textAlignment = .right
		NSLayoutConstraint.activate([
			movesCounterLabel.centerYAnchor.constraint(equalTo: newGameButton.centerYAnchor),
			movesCounterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
			movesCounterLabel.widthAnchor.constraint(equalToConstant: 150)
		])
	}
	
	func startTimer() {
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer(_:)), userInfo: nil, repeats: true)
	}
	
	@objc func fireTimer(_ sender: Timer) -> Void {
		timerSeconds += 1
		let time = secondsToMinutesToHours(second: timerSeconds)
		timerLabel.text = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
	}
	
	func secondsToMinutesToHours(second: Int) -> (Int, Int, Int) {
		return (timerSeconds / 3600, (timerSeconds % 3600) / 60, (timerSeconds % 3600) % 60)
	}
	
	func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
		var timeString = ""
		timeString += String(format: "%1d", hours)
		timeString += ":"
		timeString += String(format: "%02d", minutes)
		timeString += ":"
		timeString += String(format: "%02d", seconds)
		return timeString
	}
}

extension PuzzleBoardVC:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func createSmallCollection() {
		smallLayout.minimumLineSpacing = 0
		smallLayout.minimumInteritemSpacing = 0
		smallLayout.scrollDirection = .vertical
		view.addSubview(smallCollection)
		smallCollection.translatesAutoresizingMaskIntoConstraints = false
		smallCollection.dataSource = self
		smallCollection.delegate = self
		smallCollection.backgroundColor = .MyColor.background
		smallCollection.collectionViewLayout = smallLayout
		smallCollection.tag = 1
		NSLayoutConstraint.activate([
			smallCollection.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 20),
			smallCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			smallCollection.widthAnchor.constraint(equalToConstant: collectionWidth),
			smallCollection.heightAnchor.constraint(equalToConstant: smallCellSize * 3 + 4)
		])
	}
	
	func createBigCollection() {
		view.addSubview(bigCollection)
		bigCollection.translatesAutoresizingMaskIntoConstraints = false
		bigLayout.minimumLineSpacing = 1
		bigLayout.minimumInteritemSpacing = 0
		bigLayout.scrollDirection = .vertical
		bigCollection.delegate = self
		bigCollection.dataSource = self
		bigCollection.backgroundColor = .MyColor.background
		bigCollection.collectionViewLayout = bigLayout
		bigCollection.tag = 2
		NSLayoutConstraint.activate([
			bigCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
			bigCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			bigCollection.widthAnchor.constraint(equalToConstant: collectionWidth),
			bigCollection.heightAnchor.constraint(equalToConstant: collectionWidth)
		])
	}
	
	func populateBigEmptyImages() {
		for _ in 0...15 {
			guard let image = UIImage(systemName: "puzzlepiece.fill",
									  withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.MyColor.pink]))
			else { return }
			bigCellImages.append(ImageWithID(id: 0, image: image))
		}
	}
	
	func checkCompletion() {
		guard
			bigCellImages.sorted(by: { $0.id < $1.id }) == bigCellImages,
			bigCellImages.first?.id != 0
		else { return }
		timer.invalidate()
		let time = secondsToMinutesToHours(second: timerSeconds)
		let totalTime = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
		let alert = UIAlertController(title: "Congratulations!", message: "You did it in \(movesCounter) moves with time: \(totalTime)", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Thanks!", style: .default, handler: { _ in
			self.navigationController?.popViewController(animated: true)
		}))
		self.present(alert, animated: true)
	}
	
	func registerCells(){
		self.smallCollection.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseIdentifier)
		self.bigCollection.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseIdentifier)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if collectionView.tag == 1 {
			return CGSize(width: smallCellSize, height: smallCellSize)
		}
		return CGSize(width: bigCellSize, height: bigCellSize)
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView.tag == 1 {
			return smallCellImages.count
		}
		return bigCellImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView.tag == 1 {
			guard let smallCellUnwrapped = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseIdentifier, for: indexPath) as? CustomCell else {
				let basicSmallCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseIdentifier, for: indexPath)
				return basicSmallCell
			}
			smallCellUnwrapped.image.image = smallCellImages[indexPath.row].image
			return smallCellUnwrapped
		}
		guard let smallCellUnwrapped = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseIdentifier, for: indexPath) as? CustomCell else {
			let basicSmallCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reuseIdentifier, for: indexPath)
			return basicSmallCell
		}
		smallCellUnwrapped.image.image = bigCellImages[indexPath.row].image
		return smallCellUnwrapped
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//tag 1 - smallCollection
		if collectionView.tag == 1 {
			
			switch (selectionStatus.selectionStatus) {
					
				case .notSelected:
					self.smallCollection.performBatchUpdates {
						UIView.setAnimationsEnabled(true)
							//set border on selected cell
						self.smallCollection.cellForItem(at: indexPath)?.layer.borderWidth = 4
						self.smallCollection.cellForItem(at: indexPath)?.layer.cornerRadius = 5
						self.smallCollection.cellForItem(at: indexPath)?.layer.borderColor = selectionColor
					}
						//change selectedItem in selectionStatus
					self.selectionStatus.image = smallCellImages[indexPath.row]
					self.selectionStatus.indexPath = indexPath
					self.selectionStatus.selectionStatus = .smallCollectionSelected
					checkCompletion()
					break
					
				case .smallCollectionSelected:
					self.smallCollection.performBatchUpdates {
						UIView.setAnimationsEnabled(true)
							//delete old selection
						self.smallCollection.cellForItem(at: selectionStatus.indexPath)?.layer.borderWidth = 0
						self.smallCollection.cellForItem(at: selectionStatus.indexPath)?.layer.cornerRadius = 0
							//set new border
						self.smallCollection.cellForItem(at: indexPath)?.layer.borderWidth = 4
						self.smallCollection.cellForItem(at: indexPath)?.layer.cornerRadius = 5
						self.smallCollection.cellForItem(at: indexPath)?.layer.borderColor = selectionColor
					}
						//change selectedItem in selectionStatus
					self.selectionStatus.image = smallCellImages[indexPath.row]
					self.selectionStatus.indexPath = indexPath
					self.selectionStatus.selectionStatus = .smallCollectionSelected
					checkCompletion()
					break
					
				case .bigCollectionSelected:
					self.bigCollection.performBatchUpdates {
						UIView.setAnimationsEnabled(true)
						self.bigCollection.cellForItem(at: selectionStatus.indexPath)?.layer.borderWidth = 0
						self.bigCollection.cellForItem(at: selectionStatus.indexPath)?.layer.cornerRadius = 0
					}
					self.smallCollection.performBatchUpdates {
						UIView.setAnimationsEnabled(true)
						self.smallCollection.cellForItem(at: indexPath)?.layer.borderWidth = 4
						self.smallCollection.cellForItem(at: indexPath)?.layer.borderColor = selectionColor
						self.smallCollection.cellForItem(at: indexPath)?.layer.cornerRadius = 5
					}
					self.selectionStatus.image = smallCellImages[indexPath.row]
					self.selectionStatus.indexPath = indexPath
					self.selectionStatus.selectionStatus = .smallCollectionSelected
					checkCompletion()
					self.movesCounter += 1
					self.movesCounterLabel.text = "Moves: \(movesCounter)"
					break
			}
			
		//tag 2 - big collection
		} else if collectionView.tag == 2 {
			
			switch (selectionStatus.selectionStatus) {
					
				case .notSelected:
					self.bigCollection.performBatchUpdates {
						UIView.setAnimationsEnabled(true)
						self.bigCollection.cellForItem(at: indexPath)?.layer.borderWidth = 4
						self.bigCollection.cellForItem(at: indexPath)?.layer.borderColor = selectionColor
						self.bigCollection.cellForItem(at: indexPath)?.layer.cornerRadius = 5
					}
					self.selectionStatus.image = bigCellImages[indexPath.row]
					self.selectionStatus.indexPath = indexPath
					self.selectionStatus.selectionStatus = .bigCollectionSelected
					checkCompletion()
					break
					
				case .smallCollectionSelected:
					if self.bigCellImages[indexPath.row].image == UIImage(systemName: "puzzlepiece.extension")! {
						self.smallCollection.performBatchUpdates {
							UIView.setAnimationsEnabled(true)
							self.smallCollection.cellForItem(at: selectionStatus.indexPath)?.layer.borderWidth = 0
							self.smallCollection.cellForItem(at: selectionStatus.indexPath)?.layer.cornerRadius = 0
							self.smallCellImages.remove(at: selectionStatus.indexPath.row)
							self.smallCollection.deleteItems(at: [selectionStatus.indexPath])
						}
						self.bigCollection.performBatchUpdates {
							UIView.setAnimationsEnabled(true)
							self.bigCellImages[indexPath.row] = selectionStatus.image
							bigCollection.reloadItems(at: [indexPath])
						}
						self.selectionStatus.image = defaultImageWithID
						self.selectionStatus.indexPath = IndexPath()
						self.selectionStatus.selectionStatus = .notSelected
					} else {
						self.smallCollection.performBatchUpdates {
							self.smallCollection.cellForItem(at: selectionStatus.indexPath)?.layer.borderWidth = 0
							self.smallCollection.cellForItem(at: selectionStatus.indexPath)?.layer.cornerRadius = 0
							UIView.setAnimationsEnabled(true)
							self.smallCellImages[selectionStatus.indexPath.row] = bigCellImages[indexPath.row]
							self.smallCollection.reloadItems(at: [selectionStatus.indexPath])
						}
						self.bigCollection.performBatchUpdates {
							UIView.setAnimationsEnabled(true)
							self.bigCellImages[indexPath.row] = selectionStatus.image
							self.bigCollection.reloadItems(at: [indexPath])
						}
						self.selectionStatus.image = defaultImageWithID
						self.selectionStatus.indexPath = IndexPath()
						self.selectionStatus.selectionStatus = .notSelected
					}
					self.movesCounter += 1
					self.movesCounterLabel.text = "Moves: \(movesCounter)"
					checkCompletion()
					break
					
					
				case .bigCollectionSelected:
					self.bigCollection.performBatchUpdates {
						UIView.setAnimationsEnabled(true)
						self.bigCollection.cellForItem(at: selectionStatus.indexPath)?.layer.borderWidth = 0
						self.bigCollection.cellForItem(at: selectionStatus.indexPath)?.layer.cornerRadius = 0
						self.bigCellImages[selectionStatus.indexPath.row] = self.bigCellImages[indexPath.row]
						self.bigCellImages[indexPath.row] = self.selectionStatus.image
						bigCollection.reloadItems(at: [indexPath])
						bigCollection.reloadItems(at: [selectionStatus.indexPath])
					}
					self.selectionStatus.image = defaultImageWithID
					self.selectionStatus.indexPath = IndexPath()
					self.selectionStatus.selectionStatus = .notSelected
					self.movesCounter += 1
					self.movesCounterLabel.text = "Moves: \(movesCounter)"
					checkCompletion()
					break
			}
			
		} else {
			print("Error")
		}
	}
	
}



/*
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 if collectionView == self.CollectionViewA {
 return imageArroy.count
 }
 
 return imageArroyB.count
 
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 if collectionView == self.CollectionViewA {
 let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellA", for: indexPath) as! CollectionCellA
 // Set up cell
 cellA.lbl.text = labelA[indexPath.row]
 
 return cellA
 }
 
 else {
 let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellB", for: indexPath) as! CollectionCellB
 // ...Set up cell
 cellB.lbl.text = labelB[indexPath.row]
 
 return cellB
 }
 }
 }
 */

