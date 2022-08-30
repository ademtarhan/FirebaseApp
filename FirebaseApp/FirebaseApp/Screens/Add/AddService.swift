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
import UIKit

protocol AddService: AnyObject {
    var user: FirebaseAuth.User? { get }
    var userid: String! { get }
    var postid: String! { get }
    func saveData(data: DataModel, postImage: UIImageView, completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
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

    func saveImage(postImage: UIImageView, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let imageFolder = storageReference.child("images")
        let imageReference = imageFolder.child("\(postid ?? "")")
        // ..child("\(postid).jpg")

        if let data = postImage.image?.jpegData(compressionQuality: 0.5) {
            let imageReference = imageFolder.child("\(postid ?? "")")
            var imageUrl = ""
            imageReference.putData(data, metadata: nil) { _, error in
                if let _ = error {
                    completion(.failure(.uploadError))
                } else {
                    // ..TODO: download post datas
                    imageReference.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        imageUrl = url!.absoluteString
                        completion(.success(imageUrl))
                    }
                }
            }
        }
    }

    // ..MARK: save data with DataModel
    func saveData(data: DataModel, postImage: UIImageView, completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        databaseRef.child("posts").child(data.postID).setValue(data.asJson) { error, _ in
            if let _ = error {
                completion(.failure(FirebaseError.timeOut))
            } else {
                self.saveImage(postImage: postImage) { result in
                    switch result {
                    case let .success(imageUrl):
                        self.updateData(data: data, postid: data.postID, imageUrl: imageUrl) { result in
                            switch result {
                            case .success:
                                completion(.success(data))
                            case .failure:
                                completion(.failure(.saveError))
                            }
                        }
                    case .failure:
                        completion(.failure(.saveError))
                    }
                }
            }
        }
    }

    func updateData(data: DataModel, postid: String, imageUrl: String, completionHandler: @escaping (Result<Any, FirebaseError>) -> Void) {
        let post = DataModel(postText: data.postText, uID: data.uID, postID: data.postID, imageURL: imageUrl)
        databaseRef.child("posts").child("\(postid)").setValue(post.asJson) { error, _ in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.failure(.unKnownError))
            } else {
                print("update data")
                completionHandler(.success(true))
            }
        }
    }
}
