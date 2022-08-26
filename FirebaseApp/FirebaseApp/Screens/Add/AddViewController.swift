//
//  AddViewController.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import UIKit

protocol AddViewController: AnyObject {
    var presenter: AddPresenter? { get set }
    func navigationToHome()
    func showEmptyTextAlert()
}

class AddViewControllerImpl: UIViewController, AddViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imagePost: UIImageView!
    @IBOutlet var textPost: UITextView!
    let imagePicker = UIImagePickerController()
    var presenter: AddPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Share Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Image", style: .plain, target: self, action: #selector(addImage))
        imagePicker.delegate = self
        presenter = AddPresenterImpl(view: self)
    }

    @objc func addImage() {
        showChooeseImageType()
    }

    @IBAction func buttonSharePost(_ sender: Any) {
        presenter?.savePost(postText: textPost.text, postImage: imagePost)
     //   presenter?.saveData(postImage: imagePost, postText: textPost.text)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) // ..MARK: changed
        {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func openGallary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePost.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }
}

extension AddViewControllerImpl {
    func navigationToHome() {
        navigationController?.popViewController(animated: true)
    }

    func showChooeseImageType() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func showEmptyTextAlert() {
        let alert = UIAlertController(title: "Empty Space", message: "Please fill in the blank", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func updateUI(message: String) {
        DispatchQueue.main.async {
            // TODO: SHOW DIALOG
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
