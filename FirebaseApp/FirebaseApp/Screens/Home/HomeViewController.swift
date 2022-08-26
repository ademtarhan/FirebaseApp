//
//  HomeViewController.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import FirebaseStorage
import UIKit

protocol HomeViewController: AnyObject {
    var presenter: HomePresenter? { get set }
    func appendData(data: DataModel)
}

class HomeViewControllerImpl: UIViewController, HomeViewController {
    var presenter: HomePresenter?
    var datas = [DataModel]()
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "DEMO"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(goToAdd))

        let nibCell = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")

        presenter?.getData()
    }

    @objc func goToAdd() {
         let AddVC = AddViewControllerImpl(nibName: "AddViewController", bundle: nil)

         navigationController?.pushViewController(AddVC, animated: true)
    }

    // ..MARK: append data and reload table view
    func appendData(data: DataModel) {
        DispatchQueue.main.async {
            self.datas.append(data)
            self.tableView.reloadData()
        }
    }

    func uploadImage() {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("images")
        let imageReference = mediaFolder.child("photo")
    }
}

extension HomeViewControllerImpl {
    
   func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
            // self.navigationToLogIn()
        }))
        present(alert, animated: true, completion: nil)
    }

    func displayAlert(alert: DataDeletionAlert) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
                // self.navigationToLogIn()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    /*
     func navigationToLogIn() {
         let logInVC = LogInViewControllerImpl(nibName: "LogInViewController", bundle: nil)
         logInVC.modalPresentationStyle = .fullScreen
         logInVC.modalTransitionStyle = .crossDissolve
         present(logInVC, animated: true, completion: nil)
     }
     */
}

extension HomeViewControllerImpl: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        let item = datas[indexPath.row]
        print(item)
        cell.setdata(data: item)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let data = datas.remove(at: indexPath.row)
            presenter?.deleteData(data: data, postID: data.postID)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

extension HomeViewControllerImpl {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let _ = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            let _ = "Images/photo.jpg"
        }
    }
}
