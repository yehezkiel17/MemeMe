//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 19/07/21.
//  Copyright © 2021 Yehezkiel. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
	
	// MARK: -Variables/Constants
	let imageView: UIImageView = UIImageView()
	
	// MARK: -Lifecycle Methods
	override func awakeFromNib() {
		super.awakeFromNib()
		
		configureImageView()
	}
	
	// MARK: -Private methods
	private func configureImageView() {
		contentView.addSubview(imageView)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		let centerXConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
		let centerYConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
		let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: contentView.frame.width)
		let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: contentView.frame.height)
		
		contentView.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
	}
}
