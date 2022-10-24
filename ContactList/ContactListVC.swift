//
//  ContactListVC.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 19.10.2022.
//

import UIKit
import Kingfisher


class ContactListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let parser = Parser()
    private var usersArray = [UserParserModel]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var userModelsArray = [User]()

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
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrash))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItems = [trashButton, addButton]

    
        parser.completion = { model in
            print("completionStarted")

//            self.usersArray.append(contentsOf: model)
            print("compl: 1 and 2", model[0].name, model[1].name)

            self.saveToCoreData(model: model)
            
            
            print("model name", model.first?.name)

            self.updateTable()
//            self.deleteDuplicates()
//            print("after DELETE DUBL", self.userModelsArray.count)

            print("completionFinished")
        }
        
        self.getAllUsers()
        

    }

    @objc private func didTapTrash() {
        self.deleteAllUSers()
        self.updateTable()
    }
    @objc private func didTapAdd() {
        self.parser.getInfo()
        self.updateTable()
    }
    
    
    func saveToCoreData(model: [UserParserModel]) {
        print("saveToCoreData: 1 and 2", model[0].name, model[1].name)
        for i in model {
            self.transferParserModelToUser(parserModel: i)
        }
        print("userModelsArrayCount saveToCoreData", userModelsArray.count)

    }
    
    func transferParserModelToUser(parserModel: UserParserModel) {
        let user = User(context: context)
        user.name = "\(parserModel.name.first)@\(parserModel.name.last)"
        user.dob = "\(parserModel.dob.age)@\(parserModel.dob.date)"
        user.email = parserModel.email
        user.gender = parserModel.gender
        user.location = "\(parserModel.location.timezone.description)@\(parserModel.location.timezone.offset)"
        user.pictureURL = URL(string: parserModel.picture.thumbnail)
        
        
        self.createUser(user: user)
    }
    
    func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userModelsArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ContactsTableCell
        let model = userModelsArray[indexPath.row]
        print("nameOfCell", model.name)
        print("userModelsArray count", userModelsArray.count)

        userModelsArray.count
        cell.name.text = model.name?.replacingOccurrences(of: "@", with: " ")
        cell.avatar.kf.setImage(with: model.pictureURL)
        
        if indexPath.row == userModelsArray.count - 4{
            parser.getInfo()
            tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCard = UserCardVC()
        userCard.sendInfo(setUser: userModelsArray[indexPath.row])
        self.show(userCard, sender: self)
        
    }
    
    func getAllUsers() {
        do {
            userModelsArray = try context.fetch(User.fetchRequest())
//            print("getAllUsers: 1 and 2", userModelsArray[0].name, userModelsArray[1].name)

            DispatchQueue.main.async {
                self.updateTable()
            }
        } catch {
            print("ERROR:getAllUsers")
        }
    }
    
    func deleteDuplicates() {
        userModelsArray = Array(Set(userModelsArray))
//        for i in userModelsArray {
//
//        }
    }
    
    func createUser(user: User) {
        let newUser = User(context: context)
        newUser.name = user.name
        newUser.location = user.location
        newUser.gender = user.gender
        newUser.email = user.email
        newUser.dob = user.dob
        
        print("createUser ", newUser.name)

        print("userModelsArrayCount createUser before ", userModelsArray.count)

        do {
            try context.save()
            getAllUsers()
        } catch {
            print("ERROR: save in createUser")
        }
        
        
        print("userModelsArrayCount createUser after", userModelsArray.count)

    }
    
    func deleteUser(user: User) {
        context.delete(user)
        
        do {
            try context.save()
        } catch {
            print("ERROR: save in deleteUser")
        }
    }
    
    func deleteAllUSers() {
        do {
            let results = try context.fetch(User.fetchRequest())
            
            for i in results {
                self.deleteUser(user: i)
            }
            self.userModelsArray.removeAll()
        } catch {
            print("ERROR deleteAllUSers")
        }

    }
}
