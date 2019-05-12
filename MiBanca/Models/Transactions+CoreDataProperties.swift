//
//  Transactions+CoreDataProperties.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//
//

import Foundation
import CoreData


extension Transactions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transactions> {
        return NSFetchRequest<Transactions>(entityName: "Transactions")
    }

    @NSManaged public var username: String?
    @NSManaged public var userCardNumber: String?
    @NSManaged public var cardExpirationDate: String?
    @NSManaged public var destinationCard: String?
    @NSManaged public var destinationName: String?
    @NSManaged public var payDescription: String?
    @NSManaged public var payDate: String?
    @NSManaged public var payLatitude: String?
    @NSManaged public var payLongitude: String?
    @NSManaged public var user: User?

}
