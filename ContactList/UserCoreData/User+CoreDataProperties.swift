//
//  User+CoreDataProperties.swift
//  ContactList
//
//  Created by Stepanyan Arman  on 23.10.2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var location: String?
    @NSManaged public var email: String?
    @NSManaged public var dob: String?
    @NSManaged public var pictureURL: URL?

}

extension User : Identifiable {

}
