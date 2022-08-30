//
//  LogInInteractor.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 30.08.2022.
//

import Foundation
protocol LogInInteractor: AnyObject{
    var service: LogInService? {get set}
    func createAccount(withEmail email: String, password: String,data: [String:String], _ completion: @escaping (Result<Bool, LogInError>) -> Void)
    func logIn(with email: String,password: String, completion: @escaping (Bool) -> Void)
}

class LogInInteractorImpl: LogInInteractor{
    var service: LogInService?
    
    
    
    func createAccount(withEmail email: String, password: String, data: [String:String], _ completion: @escaping (Result<Bool, LogInError>) -> Void) {
        service?.createAccount(withEmail: email, password: password, data: data, { result in
            switch result{
            case .success(_):
                completion(.success(true))
            case .failure(_):
                completion(.failure(.unKnownError))
            }
        })
    }
    
    func logIn(with email: String,password: String, completion: @escaping (Bool) -> Void){
        service?.logIn(with: email, password: password, completion: { bool in
            switch bool{
            case true:
                completion(true)
            case false:
                completion(false)
            }
        })
    }
    
    
}
 
