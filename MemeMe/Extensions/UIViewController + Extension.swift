//
//  UIViewController + Extension.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 18/07/21.
//  Copyright © 2021 Yehezkiel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	// Get the shared memes from meme storage
	func getSharedMemes() -> [Meme] {
		let memeStorage = MemeStorage.shared
		return memeStorage.memes
	}
}
