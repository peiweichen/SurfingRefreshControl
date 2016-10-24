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
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.backgroundColor = UIColor.black
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellIdentifier")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
        //storehouserefresh,surfing,polygon,square
        surfingRefreshControl = SurfingRefreshControl.attachToScrollView(tableView, target: self, refreshAction: #selector(DemoViewController.refreshTriggered), plist: "surfing", color: UIColor.white, lineWidth: 2.0, dropHeight: 120, scale: 1.1, horizontalRandomness: 100, reverseLoadingAnimation: false, internalAnimationFactor: 0.8)
    }
    func refreshTriggered() {
        self.perform(#selector(DemoViewController.endRefresh), with: nil, afterDelay: 3.0, inModes: [RunLoopMode.commonModes])
    }
    func endRefresh() {
        surfingRefreshControl.finishLoading()
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        surfingRefreshControl.scrollViewDidScroll(scrollView)
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        surfingRefreshControl.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        cell?.selectionStyle = .none
        cell?.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(image: UIImage(named: "surfing.jpg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        cell?.contentView.addSubview(imageView)
        
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: cell?.contentView, attribute: .top, multiplier: 1, constant: 0))
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: cell?.contentView, attribute: .leading, multiplier: 1, constant: 0))
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: cell?.contentView, attribute: .trailing, multiplier: 1, constant: 0))
        cell?.contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: cell?.contentView, attribute: .bottom, multiplier: 1, constant: 0))
        
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
