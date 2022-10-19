//
//  Parser.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 19.10.2022.
//

import Foundation

class Parser {
    
    let url = URL(string: "https://randomuser.me/api/?inc=gender,name,picture,dob,email,location")
    
    func getInfo() {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let userInfo = try JSONDecoder().decode(ParserModel.self, from: data)
                print(userInfo)
                //                DispatchQueue.main.async {
                //                    goodsArray.forEach {$0.count = 1}
                //                    delegate?.loaded(goodsInfo: goodsArray)
                //                }
            }  catch {
                print(error)
            }
        }.resume()
    }
}
