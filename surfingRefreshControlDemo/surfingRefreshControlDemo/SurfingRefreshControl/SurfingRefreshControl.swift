//
//  SurfingRefreshControl.swift
//  CBStoreHouseRefreshControl
//
//  Created by chenpeiwei on 6/8/16.
//  Copyright © 2016 Peiwei Chen. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

struct SurfingConfigs {
    static let loadingIndividualAnimationTiming = 0.8
    static let barDarkAlpha:CGFloat = 0.4
    static let loadingTimingOffset = 0.1
    static let disappearDuration = 1.2
    static let relativeHeightFactor:CGFloat = 0.4
    static let startPointKey = "startPoints"
    static let endPointKey = "endPoints"
    static let xKey = "x"
    static let yKey = "y"
}

enum SurfingRefreshControlState {
    case idle
    case refreshing
    case disappearing
}

class SurfingRefreshControl: UIView {
    weak var scrollView:UIScrollView!
    var state:SurfingRefreshControlState = .idle
    var barItems:[SurfingBarItem]!
    var displayLink:CADisplayLink?
    var target:AnyObject!
    var action:Selector!
    
    var dropHeight:CGFloat!
    var disappearProgress:CGFloat!
    var internalAnimationFactor:CGFloat!
    var horizontalRandomness:Int!
    var reverseLoadingAnimation:Bool!

    var realContentOffsetY:CGFloat {
        get {
            return self.scrollView.contentOffset.y + self.scrollView.contentInset.top
        }
    }
    
    var surfingBarItemsAnimationProgress:CGFloat {
        get {
            return min(1.0,max(0,fabs(self.realContentOffsetY/self.dropHeight)))
        }
    }
    
    class func attachToScrollView(_ scrollView:UIScrollView,target:AnyObject,refreshAction:Selector,plist:String,color:UIColor=UIColor.black,lineWidth:CGFloat=2,dropHeight:CGFloat=80,scale:CGFloat=1,horizontalRandomness:Int=150,reverseLoadingAnimation:Bool=false,internalAnimationFactor:CGFloat=1.0) -> SurfingRefreshControl{
        
        let refreshControl = SurfingRefreshControl()
        refreshControl.dropHeight = dropHeight
        refreshControl.horizontalRandomness = horizontalRandomness
        refreshControl.scrollView = scrollView
        refreshControl.target = target
        refreshControl.action = refreshAction
        refreshControl.reverseLoadingAnimation = reverseLoadingAnimation
        refreshControl.internalAnimationFactor = internalAnimationFactor
        scrollView.addSubview(refreshControl)
        
        var width:CGFloat = 0
        var height:CGFloat = 0
        
        let dataDictionary = NSDictionary(contentsOfFile: Bundle.main.path(forResource: plist, ofType: "plist")!)
        let startPoints = dataDictionary?.object(forKey: SurfingConfigs.startPointKey) as! NSArray
        let endPoints = dataDictionary?.object(forKey: SurfingConfigs.endPointKey) as! NSArray
        
        for (index,startPointObject) in startPoints.enumerated() {
            let startPoint = CGPointFromString(startPointObject as! String)
            let endPoint = CGPointFromString(endPoints[index] as! String)
            
            if startPoint.x > width {
                width = startPoint.x
            }
            if endPoint.x > width {
                width = endPoint.x
            }
            if startPoint.y > height {
                height = startPoint.y
            }
            if endPoint.y > height {
                height = endPoint.y
            }
        }
        
        refreshControl.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        var surfingBarItems = [SurfingBarItem]()
        
        for (index,startPointObject) in startPoints.enumerated() {
            let startPoint = CGPointFromString(startPointObject as! String)
            let endPoint = CGPointFromString(endPoints[index] as! String)
            let surfingBarItem = SurfingBarItem(frame: refreshControl.frame, startPoint: startPoint, endPoint: endPoint, color: color, lineWidth: lineWidth)
            surfingBarItem.tag = index
            surfingBarItem.backgroundColor = UIColor.clear
            surfingBarItem.alpha = 0
            surfingBarItem.setHorizontalRandomness(refreshControl.horizontalRandomness, dropHeight: refreshControl.dropHeight)
            surfingBarItems.append(surfingBarItem)
            refreshControl.addSubview(surfingBarItem)
        }
        refreshControl.barItems = surfingBarItems
        refreshControl.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        return refreshControl
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView != self.scrollView {
            return
        }

        self.center = CGPoint(x: scrollView.frame.size.width*0.5, y: self.scrollView.contentOffset.y*SurfingConfigs.relativeHeightFactor)
        if self.state == SurfingRefreshControlState.idle {
            self.updateBarItemsWithProgress(self.surfingBarItemsAnimationProgress)
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.state == .idle && self.realContentOffsetY < -self.dropHeight {
            if self.surfingBarItemsAnimationProgress == 1 {
                self.state = .refreshing
                var newInsets = self.scrollView.contentInset
                newInsets.top += self.dropHeight
                let contentOffset = self.scrollView.contentOffset
                
                UIView.animate(withDuration: 0, animations: {
                    self.scrollView.contentInset = newInsets
                    self.scrollView.contentOffset = contentOffset
                })
                
                if self.target.responds(to: self.action) {
                    self.target.perform(self.action, with: self)
                }
                self.startLoadingAnimation()
            }
        }
    }
    
    func updateBarItemsWithProgress(_ progress:CGFloat) {
        for (index,barItem) in self.barItems.enumerated() {
            
            //internalAnimationFactor: 1 means normal animation, 0.7 cut the animation to 70% compared to normal animation, in this case , we could handle 1-0.7 = 30%.
            
            
            let startPadding = (1 - self.internalAnimationFactor)/CGFloat(self.barItems.count)*CGFloat(index)
            let endPadding = 1 - self.internalAnimationFactor - startPadding

            if (progress == 1 || progress >= 1 - endPadding) {
                barItem.transform = CGAffineTransform.identity
                barItem.alpha = SurfingConfigs.barDarkAlpha
            } else if progress == 0 {
                barItem.setHorizontalRandomness(self.horizontalRandomness, dropHeight: self.dropHeight)
            }
            else {
               
                var surfingProgress:CGFloat!
                if progress <= startPadding {
                    //key for internalAnimationFactor
                    surfingProgress = 0
                } else {
                    surfingProgress = min(1, (progress - startPadding)/self.internalAnimationFactor)
                }
                barItem.transform = CGAffineTransform(translationX: barItem.translationX*(1-surfingProgress), y: -self.dropHeight*(1-surfingProgress))
                barItem.transform = barItem.transform.rotated(by: CGFloat(M_PI)*surfingProgress)
                barItem.transform = barItem.transform.scaledBy(x: surfingProgress, y: surfingProgress)
                barItem.alpha = surfingProgress * SurfingConfigs.barDarkAlpha
            }
        }
    }
    
    func startLoadingAnimation() {
        
        //NSRunLoopCommonModes make it possible that animating even when user's dragging scrollView
        if self.reverseLoadingAnimation == true {
            for (index,barItem) in self.barItems.reversed().enumerated() {
                self.perform(#selector(SurfingRefreshControl.barItemAnimation(_:)), with: barItem, afterDelay: Double(index) * SurfingConfigs.loadingTimingOffset, inModes: [RunLoopMode.commonModes])
            }
        } else {
            for (index,barItem) in self.barItems.enumerated() {
                self.perform(#selector(SurfingRefreshControl.barItemAnimation(_:)), with: barItem, afterDelay: Double(index) * SurfingConfigs.loadingTimingOffset, inModes: [RunLoopMode.commonModes])
            }
        }
    }
    
    func finishLoading() {
        self.state = .disappearing
        self.disappearProgress = 0
        var newInset = self.scrollView.contentInset
        newInset.top = self.scrollView.contentInset.top - self.dropHeight
        UIView.animate(withDuration: SurfingConfigs.disappearDuration,animations:  {
            self.scrollView.contentInset = newInset
        }, completion: { (finished) in
            if finished {
                self.state = .idle
                self.displayLink?.isPaused = true
                self.displayLink?.invalidate()
                self.displayLink = nil
                self.disappearProgress = 1
            }
        }) 
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(SurfingRefreshControl.updateDisappearAnimation))
        self.displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func updateDisappearAnimation() {
        if (self.disappearProgress >= 0 && self.disappearProgress <= 1) {
            //60.0 means this method get called 60 times per second , 60fps
            self.disappearProgress = self.disappearProgress + CGFloat(1/60.0/SurfingConfigs.disappearDuration);
            self.updateBarItemsWithProgress(1 - self.disappearProgress)
        }
    }
    
    func barItemAnimation(_ barItem:SurfingBarItem) {
        if self.state == .refreshing {
            barItem.alpha = 1
            barItem.layer.removeAllAnimations()
           UIView.animate(withDuration: SurfingConfigs.loadingIndividualAnimationTiming, animations: {
                barItem.alpha = SurfingConfigs.barDarkAlpha
           })
        
            var isLastOne:Bool!
            
            if self.reverseLoadingAnimation == true {
                isLastOne = barItem.tag == 0
            } else {
                isLastOne = barItem.tag == self.barItems.count-1
            }
            
            //recursive
            if isLastOne == true {
                self.startLoadingAnimation()
            }
        }
    }
    
}


