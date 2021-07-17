//
//  Meme.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 18/07/21.
//  Copyright © 2021 Yehezkiel. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
	let topText: String?
	let bottomText: String?
	let originalImage: UIImage?
	let memedImage: UIImage?
	
	init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
		self.topText = topText
		self.bottomText = bottomText
		self.originalImage = originalImage
		self.memedImage = memedImage
		
		let imageRepresentation = self.memedImage!.pngData()
		let imageData = UIImage(data: imageRepresentation!)
		UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
	}
}
