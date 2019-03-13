//
//  ProductCore+CoreDataClass.swift
//  altarix3
//
//  Created by Mac on 3/2/19.
//  Copyright © 2019 Mac. All rights reserved.
//
//

import CoreData

enum TypeProduct: String, CaseIterable {
    case home = "Товары для дома"
    case eat = "Еда"
    case auto = "Товары для автомобиля"
    case none = "Прочие товары"
    case child = "Товары для детей"
}

public class ProductCore: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCore> {
        return NSFetchRequest<ProductCore>(entityName: "Product")
    }

    @NSManaged public var availability: Int64
    @NSManaged public var coastBuy: Double
    @NSManaged public var coastSell: Double
    @NSManaged public var coastSellOpt: Double
    @NSManaged public var name: String
    @NSManaged public var type: String?

}
