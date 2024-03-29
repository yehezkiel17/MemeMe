//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 18/07/21.
//  Copyright © 2021 Yehezkiel. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
	
	// MARK: -Variables/Constants
	private var memes: [Meme] {
		return getSharedMemes()
	}
	
	// MARK: -Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupNavigationBar()
		setupTableView()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		tableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let detailVC = segue.destination as? MemeDetailViewController {
			let selectedMeme = memes[tableView.indexPathForSelectedRow?.row ?? 0]
			detailVC.imageView.image = selectedMeme.memedImage
		}
	}
	
	// MARK: -Data Source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MemeTableViewCell.description()) else {
			return UITableViewCell()
		}
		
		cell.imageView?.image = memes[indexPath.row].memedImage
		
		let text = "\(memes[indexPath.row].topText ?? "") \(memes[indexPath.row].bottomText ?? "")"
		cell.textLabel?.text = text
		
		return cell
	}
	
	// MARK: -Delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "detailMeme", sender: self)
	}
	
	// MARK: -Private methods
	private func setupNavigationBar() {
		let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
		
		navigationItem.setRightBarButton(addBarButton, animated: true)
		navigationItem.title = "Sent Memes"
	}
	
	private func setupTableView() {
		tableView.tableFooterView = UIView()
		tableView.register(MemeTableViewCell.self, forCellReuseIdentifier: MemeTableViewCell.description())
	}
	
	// MARK: -objc methods
	@objc private func didTapAddButton() {
		performSegue(withIdentifier: "createMeme", sender: self)
	}
}
