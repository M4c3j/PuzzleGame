//
//  SelectedItemModel.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-18.
//

import UIKit

struct SelectedItem {
	
	var image: ImageWithID //later image with id
	var indexPath: IndexPath
	var selectionStatus: PuzzleSelectionStatus
	
	enum PuzzleSelectionStatus {
		case notSelected, smallCollectionSelected, bigCollectionSelected
	}
}
