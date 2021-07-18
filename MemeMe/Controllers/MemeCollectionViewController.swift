//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 18/07/21.
//  Copyright © 2021 Yehezkiel. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
	
	var memes: [Meme] {
		return getSharedMemes()
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return UICollectionViewCell()
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
}
