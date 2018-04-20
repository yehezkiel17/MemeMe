//
//  ViewController.swift
//  MemeMe
//
//  Created by AIMSIS on 16/4/18.
//  Copyright © 2018 AIMSIS. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
	fileprivate var memedImage: UIImage?
	fileprivate var font = "HelveticaNeue-CondensedBlack"

	// MARK: Outlets
	@IBOutlet weak var imagePickerView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var topText: UITextField!
	@IBOutlet weak var bottomText: UITextField!
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var memeView: UIView!
	
	// MARK: Actions
	// Share meme
	@IBAction func shareMeme(_ sender: UIBarButtonItem) {
		memedImage = generateMemedImage()

		let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
		activityController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
			if completed {
				self.save()
				self.dismiss(animated: true, completion: nil)
			}
		}

		present(activityController, animated: true, completion: nil)
		if let popOver = activityController.popoverPresentationController {
			popOver.sourceView = self.view
			popOver.barButtonItem = self.shareButton
		}
	}

	// Change font
	@IBAction func changeFont(_ sender: UIBarButtonItem) {
		showChooseFontAlert()
	}

	// Remove edited meme
	@IBAction func cancelMeme(_ sender: UIBarButtonItem) {
		imagePickerView.image = nil
		shareButton.isEnabled = false
		setupText()
	}

	// Pick an image from album
	@IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .photoLibrary
		pickerController.allowsEditing = true
		present(pickerController, animated: true, completion: nil)
	}

	// Pick an image from camera
	@IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .camera
		pickerController.allowsEditing = true
		present(pickerController, animated: true, completion: nil)
	}

	// Called after the controller's view is loaded into memory.
	override func viewDidLoad() {
		super.viewDidLoad()

		shareButton.isEnabled = false

		setupText()
		addHideKeyboardGesture()
	}

	// Notifies the view controller that its view is about to be added to a view hierarchy.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		subscribeToKeyboardNotifications()
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
	}

	// Notifies the view controller that its view is about to be removed from a view hierarchy.
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardNotifications()
	}

	// Notifies the container that the size of its view is about to change.
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		if UIDevice.current.orientation != .portrait {
			stackView.axis = .vertical
		} else {
			stackView.axis = .horizontal
		}
	}

	// Tells the delegate that the user picked a still image or movie.
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			imagePickerView.image = image
			imagePickerView.contentMode = .scaleAspectFit
		}
		shareButton.isEnabled = true

		dismiss(animated: true, completion: nil)
	}

	// Tells the delegate that the user cancelled the pick operation.
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	// Tells the delegate that editing began in the specified text field.
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text?.removeAll()
	}

	// Asks the delegate if the text field should process the pressing of the return button.
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	// Subscribe to keyboard notifications
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}

	// Unsubscribe to keyboard notifications
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}

	// Selector for show keyboard
	@objc func keyboardWillShow(_ notification: Notification) {
		if bottomText.isFirstResponder {
			view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}

	// Selector for hide keyboard
	@objc func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}

	// Hide keyboard when tap everywhere in view except TextField
	@objc func addHideKeyboardGesture() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(dismissKeyboard))

		view.addGestureRecognizer(tap)
	}

	// End editing and dismiss the keyboard
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}

	// Setup text
	func setupText() {
		let memeTextAttributes: [String: Any] = [
			NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
			NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
			NSAttributedStringKey.font.rawValue: UIFont(name: font, size: 40)!,
			NSAttributedStringKey.strokeWidth.rawValue: -1
		]

		topText.defaultTextAttributes = memeTextAttributes
		topText.textAlignment = .center
		topText.textColor = .white
		topText.text = "TOP"
		topText.delegate = self

		bottomText.defaultTextAttributes = memeTextAttributes
		bottomText.textAlignment = .center
		bottomText.textColor = .white
		bottomText.text = "BOTTOM"
		bottomText.delegate = self
	}

	// Get the keyboard height
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}

	// Create the meme
	func save() {
		let meme = Meme(topText: topText.text!,
						bottomText: bottomText.text!,
						originalImage: imagePickerView.image!,
						memedImage: memedImage!)

		(UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
	}

	// Generated memed image
	func generateMemedImage() -> UIImage {
		// Hide navigation bar and toolbar
		hideNavigationBarAndToolbar(isHidden: true)

		// Render view to an image
		UIGraphicsBeginImageContext(view.frame.size)
		view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		// Show navigation bar and toolbar
		hideNavigationBarAndToolbar(isHidden: false)

		return memedImage
	}

	// Hide or show the navigation bar and toolbar
	func hideNavigationBarAndToolbar(isHidden: Bool) {
		navigationBar.isHidden = isHidden
		toolbar.isHidden = isHidden
	}

	// Show alert controller for choosing font
	func showChooseFontAlert() {
		let alertController = UIAlertController(title: "Choose The Font",
										   message: "Please choose the font from this list",
										   preferredStyle: .alert)

		UIFont.fontNames(forFamilyName: "Helvetica Neue").forEach({ fontName in
			let fontAction = UIAlertAction.init(title: fontName,
												style: .default) { action in
													self.font = fontName
													self.setupText()
			}

			alertController.addAction(fontAction)
		})

		let okAction = UIAlertAction(title: "OK",
									 style: .cancel) { action in
										self.dismiss(animated: true, completion: nil)
		}

		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
}

// Meme struct
public struct Meme {
	let topText: String?
	let bottomText: String?
	let originalImage: UIImage?
	let memedImage: UIImage?

	init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
		self.topText = topText
		self.bottomText = bottomText
		self.originalImage = originalImage
		self.memedImage = memedImage

		let imageRepresentation = UIImagePNGRepresentation(self.memedImage!)
		let imageData = UIImage(data: imageRepresentation!)
		UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
	}
}

