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
		
		title = "Sent Memes"
		
		setupFlowLayout()
		setupNavigationBar()
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
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as? MemeCollectionViewCell else {
			return UICollectionViewCell()
		}
		
		cell.imageView.image = memes[indexPath.item].memedImage
		
		return cell
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
	
	// MARK: -Private methods
	private func setupNavigationBar() {
		let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
		
		navigationItem.setRightBarButton(addBarButton, animated: true)
	}
	
	// MARK: -objc methods
	@objc private func didTapAddButton() {
		performSegue(withIdentifier: "createMeme", sender: self)
	}
}
