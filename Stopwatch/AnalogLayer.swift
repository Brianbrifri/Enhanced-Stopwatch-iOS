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
    
    // Mark: - Create and add sublayers
    override func draw(in ctx: CGContext) {
        let newBounds = bounds.insetBy(dx: 20, dy: 30)
        
        // Ticks layer
        UIGraphicsPushContext(ctx)
        ticksLayer.bounds = newBounds
        ticksLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        ticksLayer.contents = UIImage(named: "stopwatch_dark")?.cgImage
        addSublayer(ticksLayer)
        
        // Seconds layer
        let labels = ["60", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
//        let center = CGPoint(x: ticksLayer.bounds.size.width / 2, y: ticksLayer.bounds.size.height / 2)
        for index in 0..<labels.count {
//            let angle = CGFloat(Double(index) * M_PI / 6.0)
//            let textFrame = CGRect(x: (center.x + sin(angle) * ticksLayer.bounds.midX * 0.7) - 4, y: (center.y - cos(angle) * ticksLayer.bounds.midY * 0.7), width: 40.0, height: 40.0)
            let textLayer = CATextLayer()
            textLayer.string = labels[index]
            textLayer.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
            textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            let vertex: CGFloat = ticksLayer.bounds.midY / textLayer.bounds.height
            textLayer.anchorPoint = CGPoint(x: 0.5, y: vertex - 1.2) // Inset of 1.2 so numbers appear inside dial
            textLayer.alignmentMode = kCAAlignmentCenter
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(Double(index) * M_PI / 6)))
            ticksLayer.addSublayer(textLayer)
        }
        
        
        // Lap hand layer
        lapTimerLayer.bounds = newBounds
        lapTimerLayer.position = CGPoint(x: newBounds.midX, y: newBounds.midY)
        lapTimerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        lapTimerLayer.contents = lapHand()?.cgImage
        addSublayer(lapTimerLayer)
        
        // Time hand layer
        mainTimerLayer.bounds = newBounds
        mainTimerLayer.position = CGPoint(x: newBounds.midX, y: newBounds.midY)
        mainTimerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mainTimerLayer.contents = timeHand()?.cgImage
        addSublayer(mainTimerLayer)
        UIGraphicsPopContext()

    }
    
    // Mark: - Time hand image function
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
    
    // Mark: - Lap hand image function
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
    
    // Mark: - Hand rotation functions
    // Used a duration of 0.001 to make the animations smooth
    // between such short movements
    func rotateMainTimer(with transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(0.001)
        mainTimerLayer.setAffineTransform(transform)
    }
    
    func rotateLapTimer(with transform: CGAffineTransform) {
        CATransaction.setAnimationDuration(0.001)
        lapTimerLayer.setAffineTransform(transform)
    }
}
