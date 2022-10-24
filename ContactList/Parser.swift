//
//  Parser.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 19.10.2022.
//

import Foundation

class Parser {
    
    typealias ResultCompletion = (Result<[UserParserModel], Error>) -> ()
    
    private static let url = URL(string: "https://randomuser.me/api/?inc=gender,name,picture,dob,email,location&results=15")

    func getInfo(completion: @escaping ResultCompletion) {
        guard let url = Self.url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let userInfo = try JSONDecoder().decode(ParserModelArray.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(userInfo.results))
                }
            }  catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
