//
//  DemoViewController.swift
//  surfingRefreshControlDemo
//
//  Created by chenpeiwei on 6/10/16.
//
//

import UIKit

class DemoViewController: UITableViewController {
    
    var surfingRefreshControl:SurfingRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Surfing"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.tableView.backgroundColor = UIColor.blackColor()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellIdentifier")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .None
        
        //storehouserefresh,surfing,polygon,square
        surfingRefreshControl = SurfingRefreshControl.attachToScrollView(tableView, target: self, refreshAction: #selector(DemoViewController.refreshTriggered), plist: "surfing", color: UIColor.whiteColor(), lineWidth: 2.0, dropHeight: 120, scale: 1.1, horizontalRandomness: 100, reverseLoadingAnimation: false, internalAnimationFactor: 0.8)
    }
    func refreshTriggered() {
        self.performSelector(#selector(DemoViewController.endRefresh), withObject: nil, afterDelay: 3.0, inModes: [NSRunLoopCommonModes])
    }
    func endRefresh() {
        surfingRefreshControl.finishLoading()
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        surfingRefreshControl.scrollViewDidScroll(scrollView)
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        surfingRefreshControl.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
        cell?.selectionStyle = .None
        cell?.backgroundColor = UIColor.clearColor()
        
        let imageView = UIImageView(image: UIImage(named: "surfing.jpg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        cell?.contentView.addSubview(imageView)
        
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: cell?.contentView, attribute: .Top, multiplier: 1, constant: 0))
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Leading, relatedBy: .Equal, toItem: cell?.contentView, attribute: .Leading, multiplier: 1, constant: 0))
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Trailing, relatedBy: .Equal, toItem: cell?.contentView, attribute: .Trailing, multiplier: 1, constant: 0))
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: cell?.contentView, attribute: .Bottom, multiplier: 1, constant: 0))

        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
}
