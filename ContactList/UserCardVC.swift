//
//  UserCardVC.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 24.10.2022.
//

import UIKit
import SnapKit
import SimpleImageViewer

class UserCardVC: UIViewController {
    
    let cardView = UserCardView()
    
    override func loadView() {
        self.view = cardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardView.completion = { image in
            let configuration = ImageViewerConfiguration { config in
                config.imageView = image
            }
            let imageViewerController = ImageViewerController(configuration: configuration)
            self.present(imageViewerController, animated: true)
        }
    }
    
    func sendInfo(setUser: User) {
        cardView.sendInfo(setUser: setUser)
    }
}
