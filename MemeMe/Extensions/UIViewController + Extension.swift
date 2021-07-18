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
	
	// Get the shared memes from app delegate object
	func getSharedMemes() -> [Meme] {
		let object = UIApplication.shared.delegate
		
		guard let appDelegate = object as? AppDelegate else {
			return []
		}
		
		return appDelegate.memes
	}
}
