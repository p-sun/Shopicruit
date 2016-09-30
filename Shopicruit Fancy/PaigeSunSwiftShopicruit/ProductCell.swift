//
//  ProductCell.swift
//  PaigeSunSwiftShopicruit
//
//  Created by Paige Sun on 2016-09-29.
//  Copyright © 2016 Paige Sun. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setLabels(variant: Variant) {
        nameLabel.text = variant.title
        priceLabel.text = "$\(variant.price)"
        self.userInteractionEnabled = false
    }
}
