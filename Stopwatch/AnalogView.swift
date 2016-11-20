//
//  AnalogView.swift
//  Stopwatch
//
//  Created by vm mac on 11/16/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class AnalogView: UIView {
    
    private(set) var analogLayer: AnalogLayer?

    override func draw(_ rect: CGRect) {

        if analogLayer == nil {
            analogLayer = AnalogLayer()
            layer.addSublayer(analogLayer!)
        }
        
        analogLayer?.frame = rect
        analogLayer?.setNeedsDisplay()
    }
    
    //Mark: - Create transforms to send to hands in AnalogLayer
    func rotateMainHand(with timestamp: TimeInterval) {
        analogLayer?.rotateMainTimer(with: CGAffineTransform(rotationAngle: CGFloat(timestamp * M_PI / 30)))
    }
    
    func rotateLapHand(with timestamp: TimeInterval) {
        analogLayer?.rotateLapTimer(with: CGAffineTransform(rotationAngle: CGFloat(timestamp * M_PI / 30)))
    }
    
    //Reset to hands at 0
    func resetDefaults() {
        analogLayer?.rotateMainTimer(with: CGAffineTransform(rotationAngle: CGFloat(60 * M_PI) / 30))
        analogLayer?.rotateLapTimer(with: CGAffineTransform(rotationAngle: CGFloat(60 * M_PI) / 30))
    }
 

}
