//
//  SessionManager.swift
//  PaigeSunSwiftShopicruit
//
//  Created by Paige Sun on 2016-09-29.
//  Copyright © 2016 Paige Sun. All rights reserved.
//

import Foundation

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
