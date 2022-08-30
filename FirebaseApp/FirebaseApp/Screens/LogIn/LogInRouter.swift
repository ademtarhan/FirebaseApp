//
//  LogInRouter.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 30.08.2022.
//

import Foundation

class LogInRouter{
    
    public static var shared = LogInRouter()
    
    var login: LogInViewController{
        let view: LogInViewController = LogInViewControllerImpl(nibName: "LogInViewController", bundle: nil)
        let presenter : LogInPresenter = LogInPresenterImpl()
        let interactor: LogInInteractor = LogInInteractorImpl()
        let service: LogInService = LogInServiceImpl()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.service = service
        return view
    }
    
}
