//
//  Wheel.swift
//  AutoLayoutTest
//
//  Created by John Green on 21/09/2014.
//  Copyright (c) 2014 AngryYak. All rights reserved.
//

import QuartzCore
import UIKit

@IBDesignable
class Wheel: UIView {

    var backgroundLayer : CAShapeLayer!
    var ringLayer : CAShapeLayer!
    var imageLayer : CALayer!
    
    var rating: CGFloat = 0.6 {
        didSet { updateLayerProperties() }
    }
    
    var lineWidth : CGFloat = 10.0 {
        didSet { updateLayerProperties() }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (backgroundLayer == nil) {
            backgroundLayer = CAShapeLayer()
            layer.addSublayer(backgroundLayer)
            
            let rect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let path = UIBezierPath(ovalInRect: rect)
            backgroundLayer.path = path.CGPath
            backgroundLayer.fillColor = nil //UIColor.blueColor().CGColor
            backgroundLayer.lineWidth = lineWidth
            backgroundLayer.strokeColor = UIColor(white: 0.5, alpha: 0.5).CGColor
        }
        backgroundLayer.frame = layer.bounds
        
        if (ringLayer == nil) {
            ringLayer = CAShapeLayer()
            
            let innerRect = CGRectInset(bounds, lineWidth / 2.0, lineWidth / 2.0)
            let innerPath = UIBezierPath(ovalInRect: innerRect)
            ringLayer.path = innerPath.CGPath
            ringLayer.fillColor = nil
            ringLayer.lineWidth = lineWidth
            ringLayer.strokeColor = UIColor.blueColor().CGColor
            ringLayer.anchorPoint = CGPointMake(0.5, 0.5)
            ringLayer.transform = CATransform3DRotate(ringLayer.transform, CGFloat(-M_PI)/2.0, 0, 0, 1)
            layer.addSublayer(ringLayer)
        }
        ringLayer.frame = layer.bounds
        
        
        if (imageLayer == nil) {
            let imageMaskLayer = CAShapeLayer()
            
            let insetBounds = CGRectInset(bounds, lineWidth + 3.0, lineWidth + 3.0)
            let innerPath = UIBezierPath(ovalInRect: insetBounds)
            
            imageMaskLayer.path = innerPath.CGPath
            imageMaskLayer.fillColor = UIColor.blackColor().CGColor
            imageMaskLayer.frame = bounds
            layer.addSublayer(imageMaskLayer)
            
            imageLayer = CALayer()
            imageLayer.mask = imageMaskLayer
            imageLayer.frame = bounds
            imageLayer.backgroundColor = UIColor.lightGrayColor().CGColor
            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            layer.addSublayer(imageLayer)
            
        }
        
    }
    
    func updateLayerProperties() {
        if (ringLayer != nil) {
            ringLayer.strokeEnd = rating
        }
    }
}
