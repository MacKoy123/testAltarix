//
//  basketProduct.swift
//  altarix3
//
//  Created by Mac on 3/1/19.
//  Copyright © 2019 Mac. All rights reserved.
//

class BasketProduct {

    var product: ProductCore
    var number: Int?
    var idCoast: Int

    init(product: ProductCore, number: Int?, idCoast: Int?) {
        self.product = product
        self.number = number ?? 0
        self.idCoast = idCoast ?? 1
    }
}
