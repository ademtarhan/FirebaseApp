//
//  LogInPresenter.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 30.08.2022.
//

import Foundation

protocol LogInPresenter: AnyObject {
    var view: LogInViewController? { get set }
    var interactor: LogInInteractor? { get set }
    func createAccount(withEmail email: String?, password: String?, data: [String: String])
    func logIn(with email: String, password: String) -> Void
}

class LogInPresenterImpl: LogInPresenter {
    var interactor: LogInInteractor?
    var view: LogInViewController?
 
    func logIn(with email: String, password: String) {
        interactor?.logIn(with: email, password: password, completion: { bool in
            switch bool {
            case true:
                break
            // self.view?.navToHome()
            case false:
                break
            }
        })
    }

    func createAccount(withEmail email: String?, password: String?, data: [String: String]) {
        guard let email = email, let password = password else {
            // .. TODO: SHOW ERROR MESSAGE
            return
        }

        interactor?.createAccount(withEmail: email, password: password, data: data, { result in
            switch result {
            case .success:
                self.view?.navigateToHome()
            case .failure:
                break
            }
        })
    }
}
