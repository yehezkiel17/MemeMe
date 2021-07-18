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
	
	var memes: [Meme] {
		return getSharedMemes()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}
