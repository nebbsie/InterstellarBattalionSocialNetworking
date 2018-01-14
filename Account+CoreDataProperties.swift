//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Aaron Nebbs on 14/01/2018.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var autoLogin: Bool?
}
