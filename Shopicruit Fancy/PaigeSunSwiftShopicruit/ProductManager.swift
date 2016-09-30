//
//  ProductManager.swift
//  PaigeSunSwiftShopicruit
//
//  Created by Paige Sun on 2016-09-29.
//  Copyright © 2016 Paige Sun. All rights reserved.
//

import Foundation

struct ProductManager {
    
    private static var receiveProduct: (product: Product) -> Void = {_ in }
    
    static func getEachWatchOrClock(completion: (product: Product) -> Void) {
        receiveProduct = completion
        getWatchOrClockOnPage(1)
    }
    
    private static func getWatchOrClockOnPage(page: Int) {
        
        SessionManager.retrieveJSONFromPage(page) { json in
            
            guard json != nil else {
                print("Unable to retrieve products from page \(page).")
                return
            }
            
            let count = countProducts(json!)
            let nextPage = count == 0 ? -1 : page + 1
            if nextPage >= 0 {
                sendProductsFromJson(json!, wantedProductTypes: ["Watch", "Clock"])
                getWatchOrClockOnPage(nextPage)
            }
        }
    }
    
    private static func sendProductsFromJson(json: NSDictionary, wantedProductTypes: [String]) {
        
        let productsJson = json["products"] as! NSArray
        for p in productsJson {
            let thisTitle = p["title"] as! String
            let thisType = p["product_type"] as! String
            let product = Product(title: thisTitle)
            
            if wantedProductTypes.contains(thisType) {
                
                let variantsArray = p["variants"] as! NSArray
                for v in variantsArray {
                    let variantPrice = Double(v["price"] as! String)!
                    let variantTitle = v["title"] as! String
                    let variant = Variant(title: variantTitle, price: variantPrice)
                    product.variants.append(variant)
                }

                self.receiveProduct(product: product)
            }
        }
    }
    
    private static func countProducts(json: NSDictionary) -> Int {
        return json["products"]?.count ?? 0
    }
    
}
