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
	
	//MARK: -Outlets
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	
	// MARK: -Variables/Constants
	private var memes: [Meme] {
		return getSharedMemes()
	}
	
	//MARK: -Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupFlowLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		collectionView.reloadData()
	}
	
	//MARK: -Data Source
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return UICollectionViewCell()
	}
	
	//MARK: -Delegate
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
	
	// MARK: -Private methods
	private func setupFlowLayout() {
		let space:CGFloat = 3.0
		let dimension = (view.frame.size.width - (2 * space)) / 3.0
		
		flowLayout.minimumInteritemSpacing = space
		flowLayout.minimumLineSpacing = space
		flowLayout.itemSize = CGSize(width: dimension, height: dimension)
	}
}
