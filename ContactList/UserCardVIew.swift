//
//  UserCardVIew.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 24.10.2022.
//

import UIKit
import SnapKit
import Kingfisher

class UserCardVIew: UIView {
    
    var userInfo: User = User()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let avaImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "testImage")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Name: "
        label.textAlignment = .left
        label.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Email: "
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Location: "
        return label
    }()
    
    private let dobLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "DOB: "
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Gender: "
        return label
    }()
    
    private let genderImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let vertStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private let genderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    func setupUI() {
        
        // ava
        if self.userInfo.gender == "female" {
            self.genderImageView.image = UIImage(named: "female")
        }
        else {
            self.genderImageView.image = UIImage(named: "male")
        }
            
        // name
        nameLabel.text?.append(userInfo.name!.replacingOccurrences(of: "@", with: " "))
        
        //dob
        
        let age = userInfo.dob?.split(separator: "@")
        
        let start = (userInfo.dob?.index(userInfo.dob!.startIndex, offsetBy: 3))!
        let end = userInfo.dob?.index(userInfo.dob!.startIndex, offsetBy: 13)
        let result = userInfo.dob?[start..<end!].split(separator: "-")
        let date = "\(result![2]).\(result![1]).\(result![0])"
        
        dobLabel.text?.append("\(date) (\(age!.first ?? ""))")

        //email
        emailLabel.text?.append(userInfo.email!)
        
        //ava
        if (userInfo.pictureURL != nil) {
            avaImageView.kf.setImage(with: userInfo.pictureURL)
        }

    }
    
    
    func sendInfo(setUser: User) {
        userInfo = setUser
        print("USERINFO", userInfo)
        self.setupUI()
        
    }

    
    func setupConstraints() {
        for i in [avaImageView, vertStackView] {
            self.addSubview(i)
        }
        
        for i in [genderLabel, genderImageView] {
            self.genderStackView.addArrangedSubview(i)
        }
        
        for i in [nameLabel, locationLabel, emailLabel, dobLabel, genderStackView] {
            self.vertStackView.addArrangedSubview(i)
        }
        
        avaImageView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(15)
            $0.width.height.equalTo(250)
        }
        
        vertStackView.snp.makeConstraints{
            $0.top.equalTo(avaImageView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().inset(15)
            $0.right.equalToSuperview().inset(15)
        }
        
    }

}