//
//  LogInViewController.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 30.08.2022.
//

import UIKit

protocol LogInViewController: AnyObject {
    var presenter: LogInPresenter? {get set}
    func navigateToHome()
}

class LogInViewControllerImpl: UIViewController, LogInViewController {
    var presenter: LogInPresenter?
    @IBOutlet var emailTextField: UITextField!

    @IBOutlet var passwordTextField: UITextField! // TODO: Rename

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func didTapLogIn(_ sender: Any) {
        presenter?.logIn(with: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        navigateToHome()
    }

    @IBAction func didTapCreate(_ sender: Any) {
        let data = ["Email": emailTextField.text ?? "", "Password": passwordTextField.text ?? ""]

        presenter?.createAccount(withEmail: emailTextField.text, password: passwordTextField.text, data: data)
    }
}

extension UIViewController {
    func navigateToHome() {
        DispatchQueue.main.async {
            let homeVC = HomeViewControllerImpl(nibName: "HomeViewController", bundle: nil)
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        }
    }
}
