//
//  PuzzleLetter.swift
//  Homework10UIKit
//
//  Created by Maciej Lipiec on 2022-08-07.
//

import UIKit

class PuzzleLetterVC: UIViewController {

	let letter = "A"
	let label = UILabel()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.heightAnchor.constraint(equalToConstant: 60).isActive = true
		view.widthAnchor.constraint(equalToConstant: 40).isActive = true
		createUI()
    }
    
	func createUI() {
		createLabel()
	}
	
	
	func createLabel() {
		view.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = letter
		label.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
		label.textAlignment = .center
		label.textColor = .black
		label.backgroundColor = .systemGray2
		label.layer.cornerRadius = 5
		label.layer.shadowColor = UIColor.red.cgColor
		label.layer.shadowRadius = 5
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: view.topAnchor),
			label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

#if DEBUG
import SwiftUI
struct PuzzleLetter_Previews: PreviewProvider {
	static var previews: some View = Preview(for: PuzzleLetterVC())
		.previewLayout(.sizeThatFits)
}
#endif
