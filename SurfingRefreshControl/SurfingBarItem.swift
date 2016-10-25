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
    fileprivate var lineWidth:CGFloat = 0
    fileprivate var startPoint:CGPoint = CGPoint.zero
    fileprivate var endPoint:CGPoint = CGPoint.zero
    fileprivate var middlePoint:CGPoint = CGPoint.zero
    fileprivate var color:UIColor = UIColor.white
    
    convenience init(frame:CGRect,startPoint:CGPoint,endPoint:CGPoint,color:UIColor,lineWidth:CGFloat) {
        self.init(frame: frame)
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.color = color
        self.lineWidth = lineWidth
        self.middlePoint = CGPoint(x: (startPoint.x+endPoint.x)*0.5, y:( startPoint.y+endPoint.y)*0.5)
    }
    
    func setHorizontalRandomness(_ horizontalRandomness:Int,dropHeight:CGFloat) {
        let horizontalRandomnessCGFloat = CGFloat(horizontalRandomness)
        let ramdomNumberInt = Int(arc4random_uniform(65535))
        let randomRangeNumberCGFloat = CGFloat( ramdomNumberInt%horizontalRandomness*2 )
        self.translationX = -horizontalRandomnessCGFloat + randomRangeNumberCGFloat
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: self.startPoint)
        bezierPath.addLine(to: self.endPoint)
        self.color.setStroke()
        bezierPath.lineWidth = self.lineWidth
        bezierPath.stroke()
    }
    
}
