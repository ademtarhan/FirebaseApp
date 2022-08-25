//
//  HomeRouter.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import Foundation

class HomeRouter{
    public static var shared = HomeRouter()
    var home: HomeViewController{
        let view : HomeViewController =  HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
        let presenter : HomePresenter = HomePresenterImpl()
        let interactor : HomeInteractor = HomeInteractorImpl()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        return view
    }
    
    
}
