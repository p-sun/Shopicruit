//
//  ViewController.swift
//  PaigeSunSwiftShopicruit
//
//  Created by Paige Sun on 2016-09-28.
//  Copyright © 2016 Paige Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - IBOutlets & IBActions
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scrollMeLabel: UILabel!

    @IBAction func buttonPressed(sender: AnyObject) {

        activityIndicator.startAnimating()
        button.setTitle("", forState: UIControlState.Normal)
        
        ProductManager.getEachWatchOrClock{ product in
            dispatch_async(dispatch_get_main_queue()) {
                
                self.button.hidden = true
                self.scrollMeLabel.hidden = false
                self.activityIndicator.stopAnimating()
                
                self.totalPrice += product.priceOfAllVariants
                self.resultLabel.text = "$\(self.totalPrice)"
                self.allProducts.append(product)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - tableView datasource
    
    var totalPrice = 0.0
    var allProducts = [Product]()
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allProducts[section].title
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allProducts.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProducts[section].variants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! ProductCell
        let variantForSectionRow = allProducts[indexPath.section].variants[indexPath.row]
        cell.setLabels(variantForSectionRow)
        return cell
    }
    
    // MARK - Parallax Header Effect
    // The header has a maximum and minimum height. User can scroll past the maximum height.
    // Upon letting go, the header will bounce back to the maximum height with animation.
    
    let headerMaxHeight: CGFloat = 300
    let headerMinHeight: CGFloat = 100
    var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = tableView.tableHeaderView
        headerView.clipsToBounds = true
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsetsMake(headerMaxHeight, 0, 0, 0) // (top, left, bottom, right)
        tableView.contentOffset = CGPoint(x: 0, y: -headerMaxHeight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateHeaderView()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func updateHeaderView() {
        // Must be at least headerMinHeight tall to be a header.
        let headerHeight = max(-tableView.contentOffset.y, headerMinHeight)
        headerView.frame = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.bounds.width, height: headerHeight)
    }

}
