//
//  TableViewCell.swift
//  FirebaseApp
//
//  Created by Adem Tarhan on 29.08.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var imagePost: UIImageView!

    @IBOutlet var userIDLabel: UILabel!

    @IBOutlet var postTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: DataModel) {
        userIDLabel.text = data.uID
        postTextLabel.text = data.postText
        load(url: URL(string: data.imageURL) ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/deleteuserdatafirebase.appspot.com/o/images%2Fplaceholder.png?alt=media&token=a096e103-374a-4ed3-9a3a-b94013acf98c")!)
    }

    
    
    
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imagePost.image = image
                    }
                }
            }
        }
    }
}
