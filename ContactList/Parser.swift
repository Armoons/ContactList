//
//  Parser.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 19.10.2022.
//

import Foundation

class Parser {
    
    let url = URL(string: "https://randomuser.me/api/?inc=gender,name,picture,dob,email,location&results=15")
    var completion: (([UserModel])->())?
    
    func getInfo() {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ERROR", error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let userInfo = try JSONDecoder().decode(ParserModel.self, from: data)
//                for i in userInfo.results {
//                    print(i.name)
//                    print(i.dob)
//                    print(i.email)
//                    print(i.gender)
//                    print(i.location)
//                    print(i.picture)
//                }
                DispatchQueue.main.async {
                    let info = userInfo.results 
                    self.completion?(info)
                }
            }  catch {
                print(error)
            }
        }.resume()
    }
}
