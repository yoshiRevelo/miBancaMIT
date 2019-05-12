//
//  User+CoreDataProperties.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var user: String?
    @NSManaged public var cardsInfo: NSSet?
    @NSManaged public var transaction: NSSet?

}

// MARK: Generated accessors for cardsInfo
extension User {

    @objc(addCardsInfoObject:)
    @NSManaged public func addToCardsInfo(_ value: CardsInfo)

    @objc(removeCardsInfoObject:)
    @NSManaged public func removeFromCardsInfo(_ value: CardsInfo)

    @objc(addCardsInfo:)
    @NSManaged public func addToCardsInfo(_ values: NSSet)

    @objc(removeCardsInfo:)
    @NSManaged public func removeFromCardsInfo(_ values: NSSet)

}

// MARK: Generated accessors for transaction
extension User {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: Transactions)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: Transactions)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}
