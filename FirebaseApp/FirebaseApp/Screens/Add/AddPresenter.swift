//
//  AddPresenter.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import Foundation
import UIKit

protocol AddPresenter: AnyObject {
//    var interactor: AddInteractor? { get set }
//    var view: AddViewController? {get set}
    func savePost(postText: String, postImage: UIImageView)
}

class AddPresenterImpl: AddPresenter {
    var view: AddViewController?
    var interactor: AddInteractor?
    
    init(view: AddViewControllerImpl) {
        self.view = view
        interactor = AddInteractorImpl()
    }
/*
    func saveImage(postImage: UIImageView, postText: String) {
        interactor?.saveImage(postImage: postImage, completion: { result in
            switch result {
            case .success:
                print("image saved")
                // self.view?.updateUI(message: "Success")
                self.interactor?.savePost(postText: postText, postImage: postImage, completion: { result in
                    switch result {
                    case let .success(model):
                        //self.view?.updateUI(message: "Success")
                        self.view?.navigationToHome()
                    case let .failure(error):
                        print("error \(error.localizedDescription)")
                    }
                })
            case .failure:
                print("error-save data")
                //self.view?.updateUI(message: "Fail")
            }
        })
    }
*/
    func savePost(postText: String, postImage: UIImageView) {
        if postText == "" {
            print("text is empty")
            view?.showEmptyTextAlert()
        } else {
            interactor?.savePost(postText: postText, postImage: postImage, completion: { result in
                switch result {
                case let .success(post):
                    print(post)
                    self.view?.navigationToHome()
                case let .failure(error):
                    print(error)
                }
            })
        }
    }
}
