//
//  ViewController.swift
//  MemeMe
//
//  Created by Alec O'Connor on 11/26/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    var meme: Meme?
    
    var pickerController: UIImagePickerController?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var viewFrameIsPushedUp = false
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        share()
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        cancel()
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        presentPickerController()
    }
    @IBAction func albumButonPressed(_ sender: Any) {
        presentPickerController(fromCamera: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp(topTextfield)
        setUp(bottomTextfield)
        setUpInputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCameraIsEnabled()
        subscribeToKeyboardNotifications()
        enableShareButton()
        setUpTextfieldTargets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Preparing Initial load
    
    func setUp(_ textfield: UITextField) {
        textfield.defaultTextAttributes = Meme.textAttributes
        textfield.textAlignment = .center
        textfield.delegate = self
    }
    
    
    func setUpInputs() {
        guard let meme = meme else { return }
        topTextfield.text = meme.topText
        bottomTextfield.text = meme.bottomText
        memeImageView.image = meme.originalImage
        memeImageView.contentMode = .scaleAspectFit
    }
    
    func setUpTextfieldTargets() {
        topTextfield.addTarget(self, action: #selector(enableShareButton), for: .editingChanged)
        bottomTextfield.addTarget(self, action: #selector(enableShareButton), for: .editingChanged)
    }
    
    func setUpCameraIsEnabled() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK: - Picker Controller
    
    func presentPickerController(fromCamera: Bool = true) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.sourceType = fromCamera ? .camera : .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard view adjustments
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextfield.isEditing && !viewFrameIsPushedUp {
            viewFrameIsPushedUp = true
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        if viewFrameIsPushedUp {
            viewFrameIsPushedUp = false
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        print("Height: \(keyboardSize.cgRectValue.height)")
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Sharing
    
    func generateMemedImage() -> UIImage {
        // Hide navigation bar and toolbar
        navigationBar.isHidden = true
        toolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navigation bar and toolbar
        navigationBar.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    
    func share() {
        // Share the image
        guard let image = memeImageView.image else {
            return
        }
        let memedImage = generateMemedImage()
        meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: image, memedImage: memedImage)
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                self.alertOfSuccess()
            }
        }
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func save() {
        // Add it to the memes array in the Application Delegate
        guard let meme = meme else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func alertOfSuccess() {
        let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func enableShareButton() {
        shareButton.isEnabled = (!topTextfield.text!.isEmpty &&
                                 topTextfield.text != "TOP" &&
                                 !bottomTextfield.text!.isEmpty &&
                                 bottomTextfield.text != "BOTTOM" &&
                                 memeImageView.image != nil)
    }

}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImageView.image = image
            enableShareButton()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == topTextfield {
            if textField.text?.isEmpty ?? false {
                textField.text = "TOP"
            }
        } else if textField == bottomTextfield {
            if textField.text?.isEmpty ?? false {
                textField.text = "BOTTOM"
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextfield {
            if textField.text == "TOP" {
                textField.text = ""
            }
        } else if textField == bottomTextfield {
            if textField.text == "BOTTOM" {
                textField.text = ""
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

