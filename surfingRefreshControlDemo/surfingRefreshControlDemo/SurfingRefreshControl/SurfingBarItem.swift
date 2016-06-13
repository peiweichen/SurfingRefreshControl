//
//  SurfBarItem.swift
//  CBStoreHouseRefreshControl
//
//  Created by chenpeiwei on 6/8/16.
//  Copyright © 2016 Peiwei Chen. All rights reserved.
//

import UIKit

class SurfingBarItem: UIView {
    var translationX:CGFloat = 0
    private var lineWidth:CGFloat = 0
    private var startPoint:CGPoint = CGPointZero
    private var endPoint:CGPoint = CGPointZero
    private var middlePoint:CGPoint = CGPointZero
    private var color:UIColor = UIColor.whiteColor()
    
    convenience init(frame:CGRect,startPoint:CGPoint,endPoint:CGPoint,color:UIColor,lineWidth:CGFloat) {
        self.init(frame: frame)
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.color = color
        self.lineWidth = lineWidth
        self.middlePoint = CGPoint(x: (startPoint.x+endPoint.x)*0.5, y:( startPoint.y+endPoint.y)*0.5)
    }
    
    func setHorizontalRandomness(horizontalRandomness:Int,dropHeight:CGFloat) {
        let horizontalRandomnessCGFloat = CGFloat(horizontalRandomness)
        let ramdomNumberInt = Int(arc4random())
        let randomRangeNumberCGFloat = CGFloat( ramdomNumberInt%horizontalRandomness*2 )
        self.translationX = -horizontalRandomnessCGFloat + randomRangeNumberCGFloat
    }
    
    override func drawRect(rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(self.startPoint)
        bezierPath.addLineToPoint(self.endPoint)
        self.color.setStroke()
        bezierPath.lineWidth = self.lineWidth
        bezierPath.stroke()
    }
    
}
