//
//  BasketForCustumer+CoreDataClass.swift
//  altarix3
//
//  Created by Mac on 3/5/19.
//  Copyright © 2019 Mac. All rights reserved.
//
//

import CoreData

public class BasketForCustumer: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BasketForCustumer> {
        return NSFetchRequest<BasketForCustumer>(entityName: "BasketForCustumer")
    }

    @NSManaged public var nameInBasket: String?

    @NSManaged public var availabilityCustumer: Int64

    @NSManaged public var coastBasketProduct: Double

}
