//
//  Product.swift
//  PaigeSunSwiftShopicruit
//
//  Created by Paige Sun on 2016-09-29.
//  Copyright © 2016 Paige Sun. All rights reserved.
//

import Foundation

class Product {
    var title: String
    var variants = [Variant]()
    
    var priceOfAllVariants: Double {
        var total = 0.0
        for v in variants {
            total += v.price
        }
        return total
    }
    
    init(title: String) {
        self.title = title
    }
}

class Variant {
    var title: String
    var price: Double
    
    init(title: String, price: Double) {
        self.title = title
        self.price = price
    }
}
