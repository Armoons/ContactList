//
//  UserCardVC.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 24.10.2022.
//

import UIKit
import SnapKit

class UserCardVC: UIViewController {
    
    let cardView = UserCardView()
    
    override func loadView() {
        self.view = cardView
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()

        }

    func sendInfo(setUser: User) {
        print("URL pict vc", setUser.pictureURL as Any)
        cardView.sendInfo(setUser: setUser)
    }
    
}
