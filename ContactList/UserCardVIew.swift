//
//  UserCardView.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 24.10.2022.
//

import UIKit
import SnapKit
import Kingfisher

class UserCardView: UIView {
    
    var userInfo: User = User()
    var completion: ((UIImageView)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avaImageView.isUserInteractionEnabled = true
        avaImageView.addGestureRecognizer(tapGestureRecognizer)

        self.setupConstraints()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        completion!(tappedImage)
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
        label.textColor = .black
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Email: "
        label.textColor = .black
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Time: "
        label.textColor = .black
        return label
    }()
    
    private let dobLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "DOB: "
        label.textColor = .black
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.text = "Gender: "
        label.textColor = .black
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
        
        //location
        var offset = userInfo.location ?? ""
        let utcDateFormatter = DateFormatter()
        utcDateFormatter.dateStyle = .medium
        utcDateFormatter.timeStyle = .medium
        utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        utcDateFormatter.dateFormat = "HH:mm"
        let UTC = Date()
        
        let dateFormatter = DateFormatter()
        //        let sign = offset.substring(from: offset.startIndex)
        let index = offset.index(offset.startIndex, offsetBy: 0)
        let sign = offset.remove(at:index)
        dateFormatter.dateFormat = "HH:mm"
        var splittedUtc = utcDateFormatter.string(from: UTC).split(separator: ":")
        var splittedOffset = offset.split(separator: ":")
        var timeMinute = 0
        var timeHours = 0
        let utsHours = Int(splittedUtc[0])!
        let utsMinutes = Int(splittedUtc[1])!
        let offsetHours = Int(splittedOffset[0])!
        let offsetMinutes = Int(splittedOffset[1])!
        
        print("UTC", splittedUtc)
        print("sign", sign)
        print("timeWithoutSign", splittedOffset)
        
        if sign == "+" {
            if utsMinutes + offsetMinutes >= 60 {
                timeHours = (offsetHours + utsHours + 1) % 24
            } else {
                timeHours += (offsetHours + utsHours) % 24
            }
            timeMinute = (utsMinutes + offsetMinutes) % 60
        } else {
            if utsMinutes - offsetMinutes <= 0 {
                timeMinute = 60 + utsMinutes - offsetMinutes
                timeHours = (24 + utsHours - offsetHours - 1) % 24
            } else {
                timeMinute = utsMinutes - offsetMinutes
                timeHours = (24 + utsHours - offsetHours) % 24
            }
        }
        print((20-30))
        if timeMinute < 10 && timeHours < 10{
            locationLabel.text?.append("0\(timeHours):0\(timeMinute)")
        } else if timeMinute < 10{
            locationLabel.text?.append("\(timeHours):0\(timeMinute)")
        } else if timeHours < 10{
            locationLabel.text?.append("0\(timeHours):\(timeMinute)")
        } else {
            locationLabel.text?.append("\(timeHours):\(timeMinute)")

        }

        
        
    }
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
        
            return dateFormatter.string(from: date)
        }
        return nil
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
