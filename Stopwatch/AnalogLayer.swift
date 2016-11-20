//
//  AnalogLayer.swift
//  Stopwatch
//
//  Created by vm mac on 11/16/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class AnalogLayer: CALayer {
    
    private var ticksLayer = CALayer()
    var mainTimerLayer = CALayer()
    var lapTimerLayer = CALayer()
    
    override func draw(in ctx: CGContext) {
        let newBounds = bounds.insetBy(dx: 20, dy: 30)
        
        UIGraphicsPushContext(ctx)
        ticksLayer.bounds = newBounds
        ticksLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        //ticksLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ticksLayer.contents = UIImage(named: "stopwatch_dark")?.cgImage
        addSublayer(ticksLayer)
        
        let labels = ["60", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
        for index in 0..<labels.count {
            let textLayer = CATextLayer()
            textLayer.string = labels[index]
            textLayer.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
            textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            let vertex: CGFloat = ticksLayer.bounds.midY / textLayer.bounds.height
            textLayer.anchorPoint = CGPoint(x: 0.5, y: vertex - 1.2)
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(Double(index) * M_PI / 6)))
            ticksLayer.addSublayer(textLayer)
        }
        
        
        lapTimerLayer.bounds = newBounds
        lapTimerLayer.position = CGPoint(x: newBounds.midX, y: newBounds.midY)
        lapTimerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        lapTimerLayer.contents = lapHand()?.cgImage
        addSublayer(lapTimerLayer)
        
        mainTimerLayer.bounds = newBounds
        mainTimerLayer.position = CGPoint(x: newBounds.midX, y: newBounds.midY)
        mainTimerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mainTimerLayer.contents = timeHand()?.cgImage
        addSublayer(mainTimerLayer)
        UIGraphicsPopContext()

    }
    
    func timeHand() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1.0)

        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.move(to: CGPoint(x: bounds.width / 2, y: 0))
            ctx.addLine(to: CGPoint(x: bounds.width / 2, y: (bounds.height / 2) + 30))
            ctx.setLineWidth(2)
            ctx.setStrokeColor(UIColor.orange.cgColor)
            ctx.strokePath()
            
            let timerImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return timerImage
        }
        return nil
    }
    
    func lapHand() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1.0)
        
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.move(to: CGPoint(x: bounds.width / 2, y: 0))
            ctx.addLine(to: CGPoint(x: bounds.width / 2, y: (bounds.height / 2) + 30))
            ctx.setLineWidth(2)
            ctx.setStrokeColor(UIColor.blue.cgColor)
            ctx.strokePath()
            
            let timerImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return timerImage
        }
        return nil
    }
    
    func rotateMainTimer(with transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(0.2)
        mainTimerLayer.setAffineTransform(transform)
    }
    
    func rotateLapTimer(with transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(0.2)
        lapTimerLayer.setAffineTransform(transform)
    }
}
