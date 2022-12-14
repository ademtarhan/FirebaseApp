//
//  HomePresenter.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import Foundation

protocol HomePresenter: AnyObject {
    var interactor: HomeInteractor? { get set }
    var view: HomeViewController? { get set }
    func getData()
    func deleteData(data: DataModel, postID: String)
}

class HomePresenterImpl: HomePresenter {
    var interactor: HomeInteractor?

    var view: HomeViewController?


    // ..MARK: get data
    func getData() {
        interactor?.getData(completion: { result in
            switch result {
            case let .success(data):
                self.view?.appendData(data: data)
            case .failure:
                break
            }
        })
    }

    // ..MARK: delete data
    func deleteData(data: DataModel, postID: String) {
        // ..
        interactor?.deleteData(with: data, postID: postID, completion: { result in
            switch result {
            case .success:

                print("success")
            case let .failure(error):
                print(error)
            }
        })
    }
}
