//
//  ContactListVC.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 19.10.2022.
//

import UIKit
import Kingfisher


class ContactListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let parser = Parser()
    var usersArray = [UserModel]()

    @IBOutlet weak var tableView: UITableView!

    let cellID = "ContactsTableCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "Contacts"
        
        let nib = UINib(nibName: cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        parser.completion = { model in
            print("completionStarted")

            self.usersArray.append(contentsOf: model)
            print("model name", model.first?.name)

            self.updateTable()
            
            print("completionFinished")
        }
        
        parser.getInfo()


    }
    
    func updateTable() {
        print("reloadData")
        tableView.reloadData()
        print("isEmpty", usersArray.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ContactsTableCell
//        parser.getInfo()
        if !usersArray.isEmpty {
            print("nameOfCell", usersArray[indexPath.row].name.first)
            cell.name.text = usersArray[indexPath.row].name.first + usersArray[indexPath.row].name.last
            let avaUrl = URL(string: usersArray[indexPath.row].picture.thumbnail)
            cell.avatar.kf.setImage(with: avaUrl)
        }
        
        if indexPath.row == usersArray.count - 4{
            parser.getInfo()
            tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        parser.getInfo()
        
    }
}
