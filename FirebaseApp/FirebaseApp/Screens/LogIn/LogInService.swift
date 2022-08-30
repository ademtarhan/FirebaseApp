//
//  LogInService.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 30.08.2022.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation

protocol LogInService: AnyObject {
    func createAccount(withEmail email: String, password: String, data: [String: String], _ completion: @escaping (Result<Bool, LogInError>) -> Void)
    func logIn(with email: String, password: String, completion: @escaping (Bool) -> Void)
}

class LogInServiceImpl: LogInService {
    let databaseRef = Database.database().reference()

    // ..MARK: creat account function
    func createAccount(withEmail email: String, password: String, data: [String: String], _ completion: @escaping (Result<Bool, LogInError>) -> Void) {
        guard let currenUserID = Auth.auth().currentUser?.uid else { return }

        Auth.auth().createUser(withEmail: email, password: password) { _, error in

            if let error = error {
                completion(.failure(.unKnownError))
            } else {
                self.databaseRef.child("Users").child("\(currenUserID)").setValue(data)

                completion(.success(true))
            }
        }
    }
    
    
    
      func logIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
          Auth.auth().signIn(withEmail: email, password: password) { _, error in
              if let error = error {
                  print("SigIn Error: \(error.localizedDescription)")
                  completion(false)
              } else {
                  print("Log In Success")
                  completion(true)
              }
          }
      }

   
}
