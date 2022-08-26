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
}

class HomeInteractorImpl: HomeInteractor {
    var service: HomeService?

   

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
