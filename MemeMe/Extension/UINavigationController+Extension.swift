//
//  UINavigationController.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 18/07/21.
//  Copyright © 2021 Yehezkiel. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

	func setStatusBar(backgroundColor: UIColor) {
		let statusBarFrame: CGRect
		
		if #available(iOS 13.0, *) {
			statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
		} else {
			statusBarFrame = UIApplication.shared.statusBarFrame
		}
		
		let statusBarView = UIView(frame: statusBarFrame)
		statusBarView.backgroundColor = backgroundColor
		view.addSubview(statusBarView)
	}
}
