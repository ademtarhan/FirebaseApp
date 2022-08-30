//
//  HomeEntity.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 25.08.2022.
//

import FirebaseCore
import FirebaseDatabase
import Foundation

struct HomeEntity {
    var text: String
    var userid: String

    func asJson() -> [String: Any] {
        return [
            "text": text,
            "userid": userid,
        ]
    }
}

enum HomeError: Error {
    case timeOut
    case invalidData
}

struct DataModel {
    var postText : String
    var uID : String
    var postID: String
    var imageURL: String
    var asJson: [String: Any] {
        return ["postText":postText, "userID":uID,"postID":postID,"imageURL":imageURL]
    }
    
    init(postText: String,uID: String,postID: String,imageURL: String){
        self.postText = postText
        self.uID = uID
        self.postID = postID
        self.imageURL = imageURL
    }

    init(snapShot: [String: Any]) {
        self.postText = snapShot["postText"] as! String
        self.uID = snapShot["userID"] as! String
        self.postID = snapShot["postID"] as! String
        self.imageURL = snapShot["imageURL"] as! String
    }
}


struct DataDeletionAlert{
    let title: String?
    let message: String?

    init(result: Bool) {
        if result {
            title = "Deleted"
            message = "Data and account is deleted"
        } else {
            title = "Error"
            message = "Data and account is not deleted"
        }
    }
}


enum FirebaseError: Error {
    case timeOut
    case wrongPassword
    case invalidEmail
    case unKnownError
    case documentsError
    case uploadError
    case saveError
    case deleteDeviceError
    case deleteAquariumError
    case deleteAccountError
    case removeValueError
    case deleteUserError
    case fetchAquariumsError
    case fetchDevicesError
    case networkError
    case deleteStorageDataError
    case wrongEntries
    case updateError
}
