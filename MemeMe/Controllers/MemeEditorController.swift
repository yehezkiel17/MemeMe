//
//  ViewController.swift
//  MemeMe
//
//  Created by Yehezkiel Litbagay on 16/4/18.
//  Copyright © 2018 Yehezkiel. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController {
	fileprivate var memedImage: UIImage?
	fileprivate var font = "Impact"
	
	// MARK: Outlets
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
	
	// MARK: Actions
	@IBAction func shareMeme(_ sender: UIBarButtonItem) {
		memedImage = generateMemedImage()
		
		let activityController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
		activityController.completionWithItemsHandler = { (_: UIActivity.ActivityType?, completed: Bool, _: [Any]?, _: Error?) in
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
	
	@IBAction func cancelMeme(_ sender: UIBarButtonItem) {
		cancelButton.isEnabled = false
		imagePickerView.image = nil
		shareButton.isEnabled = false
		setupText()
	}
	
	@IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .photoLibrary
		pickerController.allowsEditing = true
		present(pickerController, animated: true, completion: nil)
	}
	
	@IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .camera
		pickerController.allowsEditing = true
		present(pickerController, animated: true, completion: nil)
	}
	
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
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	private func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
											   name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
											   name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func setupNavigationBar() {
		navigationController?.setStatusBar(backgroundColor: UIColor.systemBlue)
		navigationController?.navigationBar.isHidden = true
		
		navigationBar.backgroundColor = .systemBlue
		navigationBar.tintColor = .white
	}
	
	private func setupText() {
		let memeTextAttributes: [String: Any] = [
			NSAttributedString.Key.strokeColor.rawValue: UIColor.black,
			NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
			NSAttributedString.Key.font.rawValue: UIFont(name: font, size: 40) ?? UIFont.boldSystemFont(ofSize: 40),
			NSAttributedString.Key.strokeWidth.rawValue: -1
		]
		
		topText.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
		topText.textAlignment = .center
		topText.textColor = .white
		topText.text = "TOP"
		topText.delegate = self
		
		bottomText.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
		bottomText.textAlignment = .center
		bottomText.textColor = .white
		bottomText.text = "BOTTOM"
		bottomText.delegate = self
	}
	
	private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
		return keyboardSize?.cgRectValue.height ?? 0
	}
	
	private func save() {
		let meme = Meme(topText: topText.text!,
						bottomText: bottomText.text!,
						originalImage: imagePickerView.image!,
						memedImage: memedImage!)
		
		(UIApplication.shared.delegate as? AppDelegate)?.memes.append(meme)
	}
	
	private func generateMemedImage() -> UIImage {
		hideNavigationBarAndToolbar(isHidden: true)
		
		UIGraphicsBeginImageContext(memeView.frame.size)
		memeView.drawHierarchy(in: imagePickerView.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		hideNavigationBarAndToolbar(isHidden: false)
		
		return memedImage
	}
	
	private func hideNavigationBarAndToolbar(isHidden: Bool) {
		navigationBar.isHidden = isHidden
		toolbar.isHidden = isHidden
	}
	
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
	
	@objc func keyboardWillShow(_ notification: Notification) {
		if bottomText.isFirstResponder {
			view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}
	
	@objc func addHideKeyboardGesture() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(dismissKeyboard))
		
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
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

private func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
