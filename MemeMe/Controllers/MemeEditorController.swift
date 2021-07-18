//
//  ViewController.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 16/4/18.
//  Copyright © 2018 Yehezkiel. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController {
	
	// MARK: -Outlets
	@IBOutlet weak var imagePickerView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var topText: UITextField!
	@IBOutlet weak var bottomText: UITextField!
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var memeView: UIView!
	
	// MARK: -Variables/Constants
	private var memedImage: UIImage?
	private var font = "Impact"
	
	// MARK: -Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		shareButton.isEnabled = false
		
		setupNavigationBar()
		setupText()
		addHideKeyboardGesture()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		subscribeToKeyboardNotifications()
		
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		cancelButton.isEnabled = imagePickerView.image != nil
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		unsubscribeFromKeyboardNotifications()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		if UIDevice.current.orientation == .portrait {
			stackView.axis = .horizontal
		} else {
			stackView.axis = .vertical
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
	// MARK: -Actions
	// Share meme through UIActivityViewController
	@IBAction func shareMeme(_ sender: UIBarButtonItem) {
		memedImage = generateMemedImage()
		
		guard let memedImage = self.memedImage else {
			return
		}
		
		let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
		activityController.completionWithItemsHandler = { (_, completed, _, _) in
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
	
	@IBAction func changeFont(_ sender: UIBarButtonItem) {
		showChooseFontAlert()
	}
	
	// Setup some views after tap the cancel buttons
	@IBAction func cancelMeme(_ sender: UIBarButtonItem) {
		cancelButton.isEnabled = false
		imagePickerView.image = nil
		shareButton.isEnabled = false
		setupText()
	}
	
	@IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
		pickImage(source: .photoLibrary)
	}
	
	@IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
		pickImage(source: .camera)
	}
	
	// MARK: -Private methods
	// Add the notification observer and call this when controller appears
	private func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
											   name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
											   name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// Remove the notification observer and call this when controller disappears
	private func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// Setup the navigation bar
	private func setupNavigationBar() {
		navigationBar.delegate = self
		navigationBar.backgroundColor = .systemBlue
		navigationBar.tintColor = .white
	}
	
	// Setup the two of text fields
	private func setupText() {
		setupTextField(textField: topText, text: "TOP")
		setupTextField(textField: bottomText, text: "BOTTOM")
	}
	
	// Setup the text field with attributes
	private func setupTextField(textField: UITextField, text: String) {
		let memeTextAttributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.strokeColor: UIColor.black,
			NSAttributedString.Key.foregroundColor: UIColor.white,
			NSAttributedString.Key.font: UIFont(name: font, size: 40) ?? UIFont.boldSystemFont(ofSize: 40),
			NSAttributedString.Key.strokeWidth: -1
		]
		
		textField.defaultTextAttributes = memeTextAttributes
		textField.textAlignment = .center
		textField.textColor = .white
		textField.text = text
		textField.delegate = self
	}
	
	// Getting the keyboard hight
	private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		guard let userInfo = notification.userInfo else {
			return 0
		}
		
		let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
		return keyboardSize?.cgRectValue.height ?? 0
	}
	
	// Save the meme struct
	private func save() {
		guard let originalImage = imagePickerView.image, let memedImage = memedImage else {
			return
		}
		
		let meme = Meme(topText: (topText.text ?? ""),
						bottomText: (bottomText.text ?? ""),
						originalImage: originalImage,
						memedImage: memedImage)
		
		(UIApplication.shared.delegate as? AppDelegate)?.memes.append(meme)
	}
	
	// Generate the meme image by UI Graphics Image Context
	private func generateMemedImage() -> UIImage {
		hideNavigationBarAndToolbar(isHidden: true)
		
		UIGraphicsBeginImageContext(memeView.frame.size)
		memeView.drawHierarchy(in: imagePickerView.frame, afterScreenUpdates: true)
		
		guard let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
			return UIImage()
		}
		
		UIGraphicsEndImageContext()
		
		hideNavigationBarAndToolbar(isHidden: false)
		
		return memedImage
	}
	
	// Hide the navigation bar and toolbar
	private func hideNavigationBarAndToolbar(isHidden: Bool) {
		navigationBar.isHidden = isHidden
		toolbar.isHidden = isHidden
	}
	
	// The dialog for change the font
	private func showChooseFontAlert() {
		let alertController = UIAlertController(title: "Choose The Font",
												message: "Please choose the font from this list",
												preferredStyle: .alert)
		
		for family in UIFont.familyNames {
			for font in UIFont.fontNames(forFamilyName: family) {
				let fontAction = UIAlertAction(title: font,
											   style: .default) { _ in
					self.font = font
					self.setupText()
				}
				
				alertController.addAction(fontAction)
			}
		}
		
		let okAction = UIAlertAction(title: "OK",
									 style: .cancel) { _ in
			self.dismiss(animated: true, completion: nil)
		}
		
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	// Pick the image based on source
	private func pickImage(source: UIImagePickerController.SourceType) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = source
		pickerController.allowsEditing = true
		present(pickerController, animated: true, completion: nil)
	}
	
	// MARK: -objc Methods
	// Set the view origin y after showing keyboard
	@objc private func keyboardWillShow(_ notification: Notification) {
		if bottomText.isFirstResponder {
			view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	// Set the view origin y after hiding keyboard
	@objc private func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}
	
	// The objc function for show or hide the keyboard from gesture
	@objc private func addHideKeyboardGesture() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(dismissKeyboard))
		
		view.addGestureRecognizer(tap)
	}
	
	// The objc function for dismissKeyboard
	@objc private func dismissKeyboard() {
		view.endEditing(true)
	}
}

extension MemeEditorController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		
		let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
		
		if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)]
			as? UIImage {
			imagePickerView.image = image
			imagePickerView.contentMode = .scaleAspectFit
		}
		shareButton.isEnabled = true
		cancelButton.isEnabled = true
		
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}

extension MemeEditorController: UINavigationBarDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		return .topAttached
	}
}

extension MemeEditorController: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text?.removeAll()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

//MARK: -Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
	_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
