//
//  AddService.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Foundation

protocol AddService: AnyObject {
    var user: FirebaseAuth.User? { get }
    var userid: String! { get }
    var postid: String! { get }
    func saveData(data: DataModel, completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func saveImage(postText: String, postImage: UIImageView, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func downUrl(postID: String, completion: @escaping (Result<URL, FirebaseError>) -> Void)
}

class AddServiceImpl: AddService {
    var postId: String = ""
    let databaseRef = Database.database().reference()

    var userid: String! {
        Auth.auth().currentUser?.uid ?? ""
    }

    var postid: String! {
        Database.database().reference().childByAutoId().key ?? ""
    }

    var user: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    func downUrl(postID: String, completion: @escaping (Result<URL, FirebaseError>) -> Void) {
        let imageReference = Storage.storage().reference().child("images").child("\(postId)")
        _ = Storage.storage().reference().child("images/\(postID)")

        imageReference.downloadURL { url, error in
            if let err = error {
                print("Error--\(err.localizedDescription)")
            } else {
//                guard let imageUrl = url?.absoluteString else {
//                    print("invalid url for image")
//                    return
//                }
                guard let imageUrl = url else {
                    print("invalid url from image")
                    return
                }
                completion(.success(imageUrl))
            }
        }
    }

    func saveImage(postText: String, postImage: UIImageView, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageFolder = storageReference.child("images").child("\(postid).jpeg")

        // .
        if let data = postImage.image?.jpegData(compressionQuality: 0.5) {
            let imageReference = imageFolder.child("\(postId)")
            imageReference.putData(data, metadata: nil) { _, error in
                if let _ = error {
                    completion(.failure(.uploadError))
                } else {
                    // ..TODO: download post datas
                    completion(.success(true))
                }
            }
        }
    }

    // ..MARK: save data with DataModel
    func saveData(data: DataModel, completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        postId = databaseRef.child("posts").childByAutoId().key ?? "postid"
        databaseRef.child("posts").child("\(postId)").setValue(data.asJson) { error, _ in
            if let _ = error {
                completion(.failure(FirebaseError.timeOut))
            } else {
                print("data is saved")
                completion(.success(data))
            }
        }
    }
}
