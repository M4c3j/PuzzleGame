//
//  SmallCell.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-08.
//

import UIKit

class CustomCell: UICollectionViewCell {
	static let reuseIdentifier = "SmallCell"
	
	let image = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.layer.cornerRadius = 5
		contentView.clipsToBounds = true
		image.image = UIImage(systemName: "1.circle.fill")
		image.backgroundColor = .MyColor.lightpink
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFit
		contentView.addSubview(image)
		NSLayoutConstraint.activate([
			image.topAnchor.constraint(equalTo: contentView.topAnchor),
			image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func prototypeNumber(with number: Int) {
		image.image = UIImage(systemName: "\(number).circle.fill")
	}
	
}
