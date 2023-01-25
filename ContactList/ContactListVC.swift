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
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var userModelsArray = [User]()
    
    private var canLoadNext: Bool = true

    @IBOutlet weak var tableView: UITableView!

    static private let cellID = "ContactsTableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "Contacts"
        
        let nib = UINib(nibName: Self.cellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Self.cellID)
        tableView.dataSource = self
        tableView.delegate = self
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapTrash))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItems = [trashButton, addButton]

        loadNextPage()
    }

    @objc private func didTapTrash() {
        deleteAllUsers()
        tableView.reloadData()
    }
    @objc private func didTapAdd() {
        loadNextPage()
        tableView.reloadData()
    }
    
    private func loadNextPage() {
        parser.getInfo { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure:
//                self.canLoadNext = false
                self.loadCachedData()
            case .success(let data):
                let users = data.map(self.transferParserModelToUser(parserModel:))
                users.forEach(self.saveUser(user:))
                self.userModelsArray.append(contentsOf: users)
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadCachedData() {
        userModelsArray = (try? context.fetch(User.fetchRequest())) ?? []
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(userModelsArray.count)
        return userModelsArray.count
        
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellID) as? ContactsTableCell else { return UITableViewCell() }
        
        let model = userModelsArray[indexPath.row]
        cell.name.text = model.name?.replacingOccurrences(of: "@", with: " ")
        cell.avatar.kf.setImage(with: model.pictureURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Reachability.isConnectedToNetwork(){
            canLoadNext = true
            print("Internet Connection Available!")
        }else{
            canLoadNext = false
            print("Internet Connection not Available!")
        }
        print("load \(canLoadNext)")
        guard canLoadNext else { return }
        
        if indexPath.row == userModelsArray.count - 4 {
            loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCard = UserCardVC()
        userCard.sendInfo(setUser: userModelsArray[indexPath.row])
        self.present(userCard, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func transferParserModelToUser(parserModel: UserParserModel) -> User {
        let user = User(context: context)
        user.name = "\(parserModel.name.first)@\(parserModel.name.last)"
        user.dob = "\(parserModel.dob.age)@\(parserModel.dob.date)"
        user.email = parserModel.email
        user.gender = parserModel.gender
        user.location = parserModel.location.timezone.offset
        user.pictureURL = URL(string: parserModel.picture.thumbnail)
        
        return user
    }
    
    func saveUser(user: User) {
        let newUser = User(context: context)
        newUser.name = user.name
        newUser.location = user.location
        newUser.gender = user.gender
        newUser.email = user.email
        newUser.dob = user.dob

        try? context.save()
    }
    
    func deleteUser(user: User) {
        context.delete(user)
        
        try? context.save()
    }
    
    func deleteAllUsers() {
        let users = (try? context.fetch(User.fetchRequest())) ?? []
        users.forEach(deleteUser(user:))
        
        userModelsArray.removeAll()
    }
}

import SystemConfiguration

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
