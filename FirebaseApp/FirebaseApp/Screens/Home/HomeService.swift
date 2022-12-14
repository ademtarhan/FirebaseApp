//
//  HomeService.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//


import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Foundation
import UIKit

protocol HomeService {
    var user: FirebaseAuth.User? { get }
    var userid: String! { get }
    var postid: String! { get }
    func getUser(completion: @escaping (Result<FirebaseAuth.User?, FirebaseError>) -> Void)
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    

}

class HomeServiceImpl: HomeService {
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

  

    // ..MARK: creat account function
    func createAccount(withEmail email: String, password: String, data: [String: String], _ completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        guard let currenUserID = Auth.auth().currentUser?.uid else { return }

        Auth.auth().createUser(withEmail: email, password: password) { _, error in

            if let error = error {
                completion(.failure(.wrongEntries))
            } else {
                self.databaseRef.child("users").child("\(currenUserID)").setValue(data)

                completion(.success(true))
            }
        }
    }

    // ..MARK: get user function
    func getUser(completion: @escaping (Result<User?, FirebaseError>) -> Void) {
        let User = Auth.auth().currentUser
        completion(.success(User))
    }

    

    // ..MARK: get data function
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
      
        databaseRef.child("posts").getData { error, snapShot in
            if let _ = error {
                completion(.failure(.unKnownError))
            } else {
                if snapShot!.exists() {
                    guard let data = snapShot?.value as? [String: Any] else {
                        return
                    }
                    for (_, d) in data {
                        guard let dict = d as? [String: Any] else {
                            return
                        }
                        let model = DataModel(snapShot: dict)
                        completion(.success(model))
                    }
                } else {
                    completion(.failure(.documentsError))
                }
            }
        }
    }

    // ..MARK: delete data function
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        let ref = databaseRef.child("posts").child(postID)
        removeData(ref: ref) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure:
                completion(.failure(.removeValueError))
            }
        }
    }

    func removeData(ref: DatabaseReference, completion: @escaping (Result<Any, Error>) -> Void) {
        ref.removeValue { error, _ in
            if let err = error {
                print(err.localizedDescription)
                completion(.failure(err))
            } else {
                completion(.success(true))
            }
        }
    }
}

