//
//  CardsInfo+CoreDataProperties.swift
//  MiBanca
//
//  Created by Yoshi Revelo on 5/10/19.
//  Copyright © 2019 Yoshi Revelo. All rights reserved.
//
//

import Foundation
import CoreData


extension CardsInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardsInfo> {
        return NSFetchRequest<CardsInfo>(entityName: "CardsInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var cardnumber: String?
    @NSManaged public var cardExpirationDate: String?
    @NSManaged public var user: User?

}
