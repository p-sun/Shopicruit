//
//  ViewController.swift
//  PaigeSunSwiftShopicruit
//
//  Created by Paige Sun on 2016-09-28.
//  Copyright © 2016 Paige Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func buttonPressed(sender: AnyObject) {
        
        ProductManager.priceOfAllWatchesAndClocks { price in
            dispatch_async(dispatch_get_main_queue()) {
                let message = "The total price of all watches and clocks is $\(price)."
                self.resultLabel.text = message
                print(message)
            }
        }
    }
}

struct ProductManager {
    
    static func priceOfAllWatchesAndClocks(completion: (price: Double) -> Void) {
        priceOfWatchesAndClocksOnPage(1, priceSoFar: 0, completion: completion)
    }
    
    /// Tail recursively return the total accumulated price of all clocks and watches.
    private static func priceOfWatchesAndClocksOnPage(page: Int, priceSoFar: Double,
                                                      completion: (totalPrice: Double) -> Void) {
        
        SessionManager.retrieveJSONFromPage(page) { json in
            
            guard json != nil else {
                print("Unable to retrieve products from page \(page).")
                completion(totalPrice: 0)
                return
            }
            
            let pagePrice = priceOfVariantsOfType(json!, wantedProductTypes: ["Watch", "Clock"])
            let count = countProducts(json!)
            let nextPage = count == 0 ? -1 : page + 1
            
            if nextPage < 0 {
                completion(totalPrice: priceSoFar + pagePrice)
            } else {
                print("Page \(page) cost $\(pagePrice)")
                priceOfWatchesAndClocksOnPage(nextPage, priceSoFar: priceSoFar + pagePrice, completion: completion)
            }
        }
    }
    
    private static func priceOfVariantsOfType(json: NSDictionary, wantedProductTypes: [String]) -> Double {
        
        var totalPrice: Double = 0
        let products = json["products"] as! NSArray
        
        for p in products {
            let thisType = p["product_type"] as! String
            if wantedProductTypes.contains(thisType) {
                let variants = p["variants"] as! NSArray
                
                for v in variants {
                    let variantPrice = Double(v["price"] as! String)!
                    totalPrice += variantPrice
                }
            }
        }
        return totalPrice
    }
    
    private static func countProducts(json: NSDictionary) -> Int {
        return json["products"]?.count ?? 0
    }
    
}

struct SessionManager {
    
    static func retrieveJSONFromPage(page: Int, completion: (json: NSDictionary?) -> Void) {
        
        let url = NSURL(string: "https://shopicruit.myshopify.com/products.json?page=\(page)")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                completion(json: json as? NSDictionary)
            } catch {
                completion(json: nil)
            }
        }
        task.resume()
    }
    
}
