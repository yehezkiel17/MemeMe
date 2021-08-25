//
//  MemeStorage.swift
//  MemeMe
//
//  Created by Cynthia Kristina on 25/08/21.
//  Copyright © 2021 AIMSIS. All rights reserved.
//

import Foundation

class MemeStorage {
	
	static let shared = MemeStorage()
	var memes = [Meme]()
	
	private init() {}
}
