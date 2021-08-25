//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 25/08/21.
//  Copyright © 2021 Yehezkiel. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
	
	// MARK: -Variables/Constants
	let imageView: UIImageView = UIImageView()
	
	// MARK: -Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureImageView()
		configureConstraint()
	}
	
	// MARK: -Private methods
	
	private func configureImageView() {
		imageView.contentMode = .scaleAspectFit
	}
	
	private func configureConstraint() {
		view.addSubview(imageView)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		let horizontalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
		let verticalConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
		let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.width)
		let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.frame.height)
		
		view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
	}
}
