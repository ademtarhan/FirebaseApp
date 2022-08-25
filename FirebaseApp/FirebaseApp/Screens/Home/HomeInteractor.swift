//
//  HomeInteractor.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import Foundation

protocol HomeInteractor: AnyObject {
    var service: HomeService? { get set }
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void)
    func saveItem(text: String, completion: @escaping (Result<DataModel, FirebaseError>) -> Void)
}

class HomeInteractorImpl: HomeInteractor {
    var service: HomeService?

    // ..MARK: save item
    func saveItem(text: String, completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        let post = DataModel(postText: text, uID: service?.userid ?? "", postID: service?.postid ?? "", imageURL: "https://firebasestorage.googleapis.com/v0/b/deleteuserdatafirebase.appspot.com/o/image.jpeg?alt=media&token=ec43daae-df3e-404a-a2d8-89248d1e9fab")
        service?.saveData(data: post, completion: { result in
            switch result {
            case let .success(post):
                completion(.success(post))
            case .failure:
                completion(.failure(.timeOut))
            }
        })
    }

    // ..MARK: get data
    func getData(completion: @escaping (Result<DataModel, FirebaseError>) -> Void) {
        service?.getData(completion: { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    // ..MARK: delete data
    func deleteData(with data: DataModel, postID: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        service?.deleteData(with: data, postID: postID, completion: { result in
            switch result {
            case let .success(true):
                completion(.success(true))
            case let .failure(error):
                print(error)
                completion(.failure(.timeOut))
            case .success(false):
                break
            }
        })
    }
}
